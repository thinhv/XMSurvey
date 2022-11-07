//
//  QuestionsViewModel.swift
//  XMSurvey
//
//  Created by Thinh on 5.11.2022.
//

import Combine

protocol QuestionsViewModelProtocol {
    var selectedTab: Int { get set}

    func next()
    func previous()
    func load()
    func reset()
}

final class QuestionsViewModel: ObservableObject, QuestionsViewModelProtocol {
    @Published private(set) var state: LoadingState<[Question]> = .idle
    @Published private(set) var questionViewModels: [QuestionViewModel]
    @Published private(set) var isNextButtonEnabled: Bool = false
    @Published private(set) var submittedQuestions: [Question] = []

    /// Index of the current active question
    @Published private(set) var index: Int = 0

    /// Id of the current active question
    var selectedTab: Int = 0 // Can use phantom type here e.g, Id<Question>

    private let loader: APIRequestLoader<QuestionsRequest>
    private var cancellables: Set<AnyCancellable> = []

    init(loader: APIRequestLoader<QuestionsRequest> = .init(request: QuestionsRequest())) {
        self.loader = loader
        self.questionViewModels = []

        let currentQuestionViewModel: AnyPublisher<QuestionViewModel?, Never> = $index
            .combineLatest($questionViewModels)
            .map { index, viewModels in
                guard index < viewModels.count else { return nil }
                return viewModels[index]
            }
            .eraseToAnyPublisher()

        let canContinueFromCurrentQuestion = currentQuestionViewModel
            .map { $0?.$state.eraseToAnyPublisher() ?? Just(.idle).eraseToAnyPublisher()}
            .switchToLatest()
            .map { $0.isLoaded }
            .eraseToAnyPublisher()

        Publishers.CombineLatest3(canContinueFromCurrentQuestion, $index, $questionViewModels)
            .map { canContinueFromCurrentQuestion, index, questionViewModels in
                return canContinueFromCurrentQuestion && index < questionViewModels.count - 1
            }
            .sink { [weak self] isNextButtonEnabled in
                self?.isNextButtonEnabled = isNextButtonEnabled
            }
            .store(in: &cancellables)
    }

    func load() {
        reset()

        state = .loading
        loader
            .loadRequest(requestData: nil)
            .map { questions in LoadingState.loaded(questions) }
            .catch { error in Just(LoadingState.failed(error)) }
            .sink(receiveValue: { [weak self] state in
                guard let self = self else { return }

                if case let .loaded(questions) = state {
                    self.questionViewModels = questions.map { question in
                        QuestionViewModel(question: question) { [weak self] state in
                            if state.isLoaded {
                                self?.submittedQuestions.append(question)
                            }
                        }
                    }

                    if self.index < self.questionViewModels.count - 1 {
                        self.selectedTab = self.questionViewModels[self.index].id
                    }
                }

                self.state = state
            })
            .store(in: &cancellables)
    }

    func reset() {
        index = 0
        selectedTab = 0
        questionViewModels = []
        submittedQuestions = []
        state = .idle
        isNextButtonEnabled = false
    }

    func next() {
        guard state.isLoaded else { return }

        index = min(index + 1, questionViewModels.count - 1)
        selectedTab = questionViewModels[index].id
    }

    func previous() {
        guard state.isLoaded else { return }

        index = max(index - 1, 0)
        selectedTab = questionViewModels[index].id
    }
}

extension QuestionsViewModel {
    var submittedQuestionsTitle: String {
        "Question submitted: \(submittedQuestions.count)"
    }

    var indexTitle: String {
        "Questions \(index + 1)/\(questionViewModels.count)"
    }

    var isShowingQuestions: Bool {
        switch state {
            case .loaded: return true
            default: return false
        }
    }

    var isPreviousButtonEnabled: Bool {
        index != 0
    }
}

//
//  QuestionViewModel.swift
//  XMSurvey
//
//  Created by Thinh on 5.11.2022.
//

import Foundation
import Combine

final class QuestionViewModel: ObservableObject, Identifiable {
    @Published private(set) var state: LoadingState<Question> = .idle
    @Published private(set )var bannerState: BannerState = .hidden
    @Published var answer: String = ""

    let id: Int
    let question: Question

    private let request = QuestionSubmissionRequest()
    private lazy var loader = APIRequestLoader(request: request)
    private var cancellable: AnyCancellable?
    private var timer: Timer?
    private let completion: (LoadingState<Question>) -> Void

    init(question: Question, completion: @escaping (LoadingState<Question>) -> Void) {
        self.question = question
        self.id = question.id
        self.completion = completion
    }

    func submit() {
        state = .loading
        bannerState = state.bannerState

        let question = self.question
        let requestData = Answer(id: question.id, answer: answer)
        cancellable = loader
            .loadRequest(requestData: requestData)
            .map { _ in LoadingState<Question>.loaded(question) }
            .catch { error in Just(LoadingState<Question>.failed(error)) }
            .sink { [weak self] state in
                guard let self = self else { return }

                self.state = state
                self.bannerState = state.bannerState
                self.completion(state)

                self.timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
                    self?.bannerState = .hidden
                }
            }
    }

    func retry() {
        bannerState = .hidden
    }
}

extension QuestionViewModel {
    var isTextFieldEnabled: Bool {
        switch state {
            case .loaded, .loading: return false
            case .idle, .failed: return true
        }
    }

    var submitButtonTitle: String {
        switch state {
            case .idle, .failed: return "Submit"
            case .loaded: return "Already submitted"
            case .loading: return "Submitting..."
        }
    }

    var isSubmitButtonEnabled: Bool {
        switch state {
            case .idle, .failed: return !answer.isEmpty
            case .loading, .loaded: return false
        }
    }

    var isNextButtonEnabled: Bool {
        guard case .loaded = state else {
            return false
        }

        return true
    }
}


//
//  QuestionViewModel.swift
//  XMSurvey
//
//  Created by Thinh on 5.11.2022.
//
/*
import Combine

final class QuestionViewModel: ObservableObject, Identifiable {
    @Published private(set) var state: LoadingState<Void> = .idle
    @Published private(set) var isSubmitButtonEnabled: Bool = false
    @Published private(set) var isNextButtonEnabled: Bool = false
    @Published var answer: String = ""

    let id: Int
    let question: Question

    private let request = QuestionSubmissionRequest()
    private lazy var loader = APIRequestLoader(request: request)
    private var cancellables = Set<AnyCancellable>()

    init(question: Question) {
        self.question = question
        self.id = question.id
        self.$state.combineLatest(self.$answer).sink { [weak self] state, answer in
            guard let self = self else { return }
            switch state {
                case .idle, .failed:
                    self.isSubmitButtonEnabled = !answer.isEmpty
                    self.isNextButtonEnabled = false
                case .loading:
                    self.isSubmitButtonEnabled = false
                    self.isNextButtonEnabled = false
                case .loaded:
                    self.isSubmitButtonEnabled = false
                    self.isNextButtonEnabled = true
            }
        }
        .store(in: &cancellables)
    }

    func submit() {
        self.state = .loading
/*
        let requestData = Answer(id: question.id, answer: answer)
        cancellable = loader
            .loadRequest(requestData: requestData)
            .map { _ in LoadingState<Void>.loaded(()) }
            .catch { error in Just(LoadingState<Void>.failed(error)) }
            .sink { [weak self] state in
                self?.state = state
            }
        */
    }
}
*/

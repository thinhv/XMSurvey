//
//  QuestionsView.swift
//  XMSurvey
//
//  Created by Thinh on 5.11.2022.
//

import Combine
import SwiftUI

struct QuestionsView: View {
    @ObservedObject var viewModel: QuestionsViewModel

    var body: some View {
        VStack {
            Text(viewModel.submittedQuestionsTitle)

            switch viewModel.state {
                case .loading, .idle:
                    ProgressView()
                case .loaded:
                    TabView(selection: $viewModel.selectedTab) {
                        ForEach(viewModel.questionViewModels) { viewModel in
                            QuestionView(viewModel: viewModel)
                                .tag(viewModel.id)

                        }
                    }
                    .tabViewStyle(.page)
                case let .failed(error):
                    VStack {
                        // NOTE: Not good but just make it simple
                        Text(error.localizedDescription)
                    }
            }
        }
        .onAppear {
            viewModel.load()
        }
        .toolbar {
            if case .loaded = viewModel.state {
                HStack {
                    Text(viewModel.indexTitle)

                    Spacer()

                    Button("Previous") {
                        viewModel.previous()
                    }
                    .disabled(!viewModel.isPreviousButtonEnabled)

                    Button("Next") {
                        viewModel.next()
                    }
                    .disabled(!viewModel.isNextButtonEnabled)
                }
            }
        }
    }
}

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsView(viewModel: QuestionsViewModel())
    }
}

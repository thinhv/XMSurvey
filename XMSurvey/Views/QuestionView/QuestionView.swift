//
//  QuestionView.swift
//  XMSurvey
//
//  Created by Thinh on 5.11.2022.
//

import SwiftUI

struct QuestionView: View {
    @ObservedObject var viewModel: QuestionViewModel

    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Text(viewModel.question.question)

                TextField(text: $viewModel.answer) {
                    Text("Type here for an answer...")
                }
                .disabled(!viewModel.isTextFieldEnabled)

                Spacer(minLength: 100)

                HStack {
                    VStack(alignment: .center) {
                        Button(viewModel.submitButtonTitle) {
                            viewModel.submit()
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(viewModel.isSubmitButtonEnabled ? .blue : .gray)
                        .cornerRadius(8)
                        .disabled(!viewModel.isSubmitButtonEnabled)
                    }
                }

                Spacer()
            }

            VStack {
                if viewModel.bannerState != .hidden {
                    Banner(state: viewModel.bannerState) {
                        viewModel.retry()
                    }
                }
                Spacer()
            }
        }
        .padding()
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(viewModel: QuestionViewModel(question: .init(id: 1, question: "How are you?"), completion: { _ in }))
    }
}

//
//  StartViewModel.swift
//  XMSurvey
//
//  Created by Thinh on 5.11.2022.
//

import SwiftUI
import Combine

final class StartViewModel: ObservableObject {
    private var questionsViewModel: QuestionsViewModel?

    var questionsView: some View {
        let viewModel = QuestionsViewModel()
        questionsViewModel = viewModel
        return QuestionsView(viewModel: viewModel)
    }
}

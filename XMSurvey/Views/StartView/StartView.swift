//
//  StartView.swift
//  XMSurvey
//
//  Created by Thinh on 5.11.2022.
//

import SwiftUI

struct StartView: View {
    @ObservedObject var viewModel: StartViewModel

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: viewModel.questionsView) {
                    Text("Start survey")
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(viewModel: StartViewModel())
    }
}

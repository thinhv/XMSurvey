//
//  ContentView.swift
//  XMSurvey
//
//  Created by Thinh on 2.11.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var startViewModel = StartViewModel()

    var body: some View {
        StartView(viewModel: startViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  Banner.swift
//  XMSurvey
//
//  Created by Thinh on 6.11.2022.
//

import SwiftUI

enum BannerState {
    case success
    case failure
    case hidden
}

extension LoadingState {
    var bannerState: BannerState {
        switch self {
            case .loading, .idle: return .hidden
            case .loaded: return .success
            case .failed: return .failure
        }
    }
}

struct Banner: View {
    private let state: BannerState
    private let retryAction: (() -> Void)?

    init(state: BannerState, retryAction: (() -> Void)? = nil) {
        self.state = state
        self.retryAction = retryAction
    }

    var body: some View {
        VStack {
            HStack {
                Text(state.title)
                    .padding(.vertical, 80)
                    .font(.system(size: 40, weight: .bold))
                Spacer()
                if state == .failure {
                    Button("Retry") {
                        retryAction?()
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(.white, lineWidth: 2))
                }
            }
        }
        .padding(.horizontal, 16)
        .background(state.backgroundColor)
    }
}

extension BannerState {
    var title: String {
        switch self {
            case .hidden: return ""
            case .success: return "Success"
            case .failure: return "Failure!"
        }
    }

    var backgroundColor: Color {
        switch self {
            case .hidden: return .clear
            case .success: return .green
            case .failure: return .red
        }
    }
}

struct Banner_Previews: PreviewProvider {
    static var previews: some View {
        Banner(state: .failure)
    }
}

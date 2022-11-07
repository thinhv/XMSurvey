//
//  LoadingState.swift
//  XMSurvey
//
//  Created by Thinh on 7.11.2022.
//

import Foundation

enum LoadingState<Value> {
    case idle
    case loading
    case failed(Error)
    case loaded(Value)
}

extension LoadingState {
    var isIdle: Bool {
        switch self {
            case .idle: return true
            default: return false
        }
    }

    var isLoaded: Bool {
        switch self {
            case .loaded: return true
            default: return false
        }
    }

    var isLoading: Bool {
        switch self {
            case .loading: return true
            default: return false
        }
    }
}

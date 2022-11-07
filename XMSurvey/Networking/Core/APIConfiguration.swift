//
//  APIConfiguration.swift
//  XMSurvey
//
//  Created by Thinh on 5.11.2022.
//

import Foundation

import Foundation

final class APIConfiguration {

    let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }
}

extension APIConfiguration {
    static let appConfiguration = APIConfiguration(baseURL: "https://xm-assignment.web.app")
}

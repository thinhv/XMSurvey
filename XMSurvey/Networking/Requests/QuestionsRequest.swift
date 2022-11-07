//
//  QuestionsRequest.swift
//  XMSurvey
//
//  Created by Thinh on 2.11.2022.
//

import Foundation

struct QuestionsRequest: APIRequestProtocol {
    typealias ResquestDataType = String
    typealias ResponseDataType = [Question]

    private let configuration: APIConfiguration
    private let endpoint: String = "questions"

    init(_ configuration: APIConfiguration = APIConfiguration.appConfiguration) {
        self.configuration = configuration
    }

    func createRequest(_ data: String?) throws -> URLRequest {
        // Ignore data
        let urlString = "\(configuration.baseURL)/\(endpoint)"

        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        } else {
            throw RequestError.invalidURL
        }
    }

    static func parseResponse(_ data: Data) throws -> [Question] {
        try JSONDecoder().decode([Question].self, from: data)
    }
}

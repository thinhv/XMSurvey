//
//  QuestionSubmissionRequest.swift
//  XMSurvey
//
//  Created by Thinh on 5.11.2022.
//

import Foundation

struct QuestionSubmissionRequest: APIRequestProtocol {
    typealias ResquestDataType = Answer
    typealias ResponseDataType = Void

    private let configuration: APIConfiguration
    private let endpoint: String = "/question/submit"

    init(_ configuration: APIConfiguration = APIConfiguration.appConfiguration) {
        self.configuration = configuration
    }

    func createRequest(_ answer: Answer?) throws -> URLRequest {
        guard let answer = answer else {
            throw RequestError.missingData
        }

        let urlString = "\(configuration.baseURL)\(endpoint)"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            request.httpBody = try JSONEncoder().encode(answer)
            return request
        } else {
            throw RequestError.invalidURL
        }
    }

    static func parseResponse(_ data: Data) throws {}
}

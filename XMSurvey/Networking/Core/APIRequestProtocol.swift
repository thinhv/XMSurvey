//
//  APIRequestProtocol.swift
//  XMSurvey
//
//  Created by Thinh on 5.11.2022.
//

import Foundation

enum RequestError: Error {
    case missingData
    case invalidURL
}

protocol APIRequestProtocol {
    associatedtype ResquestDataType
    associatedtype ResponseDataType

    func createRequest(_ data: ResquestDataType?) throws -> URLRequest
    static func parseResponse(_ data: Data) throws -> ResponseDataType
}

//
//  APIRequestLoader.swift
//  XMSurvey
//
//  Created by Thinh on 5.11.2022.
//

import Foundation
import Combine

enum APIRequestLoaderError: Error {
    case notOk
}

class APIRequestLoader<T: APIRequestProtocol> {
    let request: T
    let session: URLSession

    init(request: T, session: URLSession = URLSession.shared) {
        self.request = request
        self.session = session
    }

    func loadRequest(requestData: T.ResquestDataType?) -> AnyPublisher<T.ResponseDataType, Error> {
        do {
            let urlRequest = try request.createRequest(requestData)
            return session.dataTaskPublisher(for: urlRequest)
                .tryMap { (data, response) in
                    if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                        throw APIRequestLoaderError.notOk
                    }
                    return try T.parseResponse(data)
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } catch {
            return Fail<T.ResponseDataType, Error>(error: error).eraseToAnyPublisher()
        }
    }
}

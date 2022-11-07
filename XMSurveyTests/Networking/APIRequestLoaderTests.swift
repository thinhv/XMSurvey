//
//  APIRequestLoaderTests.swift
//  XMSurveyTests
//
//  Created by Thinh on 6.11.2022.
//

import XCTest
@testable import XMSurvey

final class APIRequestLoaderTests: XCTestCase {

    var request: QuestionsRequest!
    var session: URLSession!
    var sut: APIRequestLoader<QuestionsRequest>!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]

        session = URLSession(configuration: configuration)
        request = QuestionsRequest(APIConfiguration(baseURL: "https://xm.com"))
        sut = .init(request: request, session: session)
    }

    override func tearDownWithError() throws {
        MockURLProtocol.handler = nil
    }

    func test_initMethod() {
        XCTAssertEqual(sut.session, session)
    }

    func test_receiveOnMainThread() {
        let expectation = expectation(description: "Awaiting request loader")
        var thread: Thread!
        MockURLProtocol.handler = { request in
            let httpResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = try JSONSerialization.data(withJSONObject: []) // Empty array of questions
            return (httpResponse, data)
        }
        let cancellable = sut.loadRequest(requestData: nil)
            .sink(
                receiveCompletion: { _ in},
                receiveValue: { _ in
                    thread = Thread.current
                    expectation.fulfill()
                }
            )

        waitForExpectations(timeout: 1.0)
        cancellable.cancel()

        XCTAssertNotNil(thread)
        XCTAssertTrue(thread.isMainThread)
    }

    func test_loadRequest_given400StatusCode_receiveNotOk() throws {
        MockURLProtocol.handler = { request in
            let httpResponse = HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!
            let data = Data()
            return (httpResponse, data)
        }

        let error = try awaitError(from: sut.loadRequest(requestData: nil)) as? APIRequestLoaderError
        XCTAssertNotNil(error)
        XCTAssertEqual(error, APIRequestLoaderError.notOk)
    }

    func test_loadRequest_givenValidJSONResponse_receiveQuestions() throws {
        MockURLProtocol.handler = { request in
            let httpResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = try Data.fromJSON(fileName: "questions")
            return (httpResponse, data)
        }

        let questions = try awaitOutput(from: sut.loadRequest(requestData: nil))
        XCTAssertEqual(questions.count, 2)
        XCTAssertEqual(questions.first!.id, 1)
        XCTAssertEqual(questions.last!.id, 2)
        XCTAssertEqual(questions.first!.question, "How are you?")
        XCTAssertEqual(questions.last!.question, "What is your name?")
    }
}

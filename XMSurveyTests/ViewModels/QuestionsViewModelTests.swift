//
//  QuestionsViewModelTests.swift
//  XMSurveyTests
//
//  Created by Thinh on 6.11.2022.
//

import XCTest
@testable import XMSurvey

final class QuestionsViewModelTests: XCTestCase {

    var session: URLSession!
    var loader: APIRequestLoader<QuestionsRequest>!
    var request: QuestionsRequest!
    var sut: QuestionsViewModel!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)
        request = .init(APIConfiguration(baseURL: "https://xm.com"))
        loader = APIRequestLoader(request: request, session: session)
        sut = QuestionsViewModel(loader: loader)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_initialLoadingState() {
        XCTAssertTrue(sut.state.isIdle)
        XCTAssertEqual(sut.index, 0)
        XCTAssertEqual(sut.selectedTab, 0)
        XCTAssertEqual(sut.submittedQuestions.count, 0)
        XCTAssertEqual(sut.isShowingQuestions, false)
    }

    func test_whenResetIsCalled_validState() {
        sut.reset()

        XCTAssertEqual(sut.index, 0)
        XCTAssertEqual(sut.selectedTab, 0)
        XCTAssertEqual(sut.submittedQuestions.count, 0)
        XCTAssertEqual(sut.isShowingQuestions, false)
    }

    func test_whenLoadIsCalled_validLoadingState() throws {
        let publisher = sut
            .$state
            .collect(1)
            .first()
            .eraseToAnyPublisher()

        sut.load()

        let updates = try awaitOutput(from: publisher)
        XCTAssertEqual(updates.count, 1)
        XCTAssertTrue(updates.first!.isLoading)
        XCTAssertTrue(sut.state.isLoading)
    }

    func test_whenFinishLoadingWithRequest_validLoadedState() throws {
        let publisher = sut
            .$state
            .dropFirst() // Drop the first value which is received right after subscribing (loading)
            .collect(1)
            .first()
            .eraseToAnyPublisher()

        MockURLProtocol.handler = { request in
            let httpResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = try Data.fromJSON(fileName: "questions")
            return (httpResponse, data)
        }

        sut.load()

        let updates = try awaitOutput(from: publisher)
        XCTAssertEqual(updates.count, 1)
        XCTAssertTrue(updates.first!.isLoaded)
        XCTAssertTrue(sut.isShowingQuestions)
        XCTAssertEqual(sut.selectedTab, 1) // First question id from "questions.json" file is 1
        XCTAssertEqual(sut.indexTitle, "Questions 1/2")
        XCTAssertEqual(sut.submittedQuestionsTitle, "Question submitted: 0")
    }

    // TODO: Implement this similar to the above tests
    func test_next_correctIndex() {}

    // TODO: Implement this similar to the above tests
    func test_previous_correctIndex() {}
}

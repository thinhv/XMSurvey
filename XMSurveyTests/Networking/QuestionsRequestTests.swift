//
//  QuestionsRequestTests.swift
//  XMSurveyTests
//
//  Created by Thinh on 6.11.2022.
//

import XCTest
@testable import XMSurvey

final class QuestionsRequestTests: XCTestCase {

    var configuration: APIConfiguration!
    var sut: QuestionsRequest!

    override func setUpWithError() throws {
        configuration = APIConfiguration(baseURL: "https://xm.com")
        sut = QuestionsRequest(configuration)
    }

    override func tearDownWithError() throws {}

    func test_validRequest() throws {
        let request = try sut.createRequest(nil)

        let url = request.url
        let expectedURL = URL(string: "https://xm.com/questions")!
        XCTAssertNotNil(url)
        XCTAssertEqual(request.url, expectedURL)
        XCTAssertEqual(request.httpMethod?.lowercased(), "get")
    }

    func test_canParseResponse() throws {
        let data = try Data.fromJSON(fileName: "questions")
        let questions = try QuestionsRequest.parseResponse(data)
        XCTAssertEqual(questions.count, 2)
    }
}

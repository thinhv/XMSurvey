//
//  QuestionSubmissionRequestTests.swift
//  XMSurveyTests
//
//  Created by Thinh on 6.11.2022.
//

import XCTest
@testable import XMSurvey

final class QuestionSubmissionRequestTests: XCTestCase {
    var configuration: APIConfiguration!
    var sut: QuestionSubmissionRequest!

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {
        configuration = nil
        sut = nil
    }

    func test_givenInvalidBaseURL_createRequestWithError() {
        configuration = APIConfiguration(baseURL: "xm trading")
        sut = QuestionSubmissionRequest(configuration)
        let requestData = Answer(id: 1, answer: "Answer")

        do {
            let _ = try sut.createRequest(requestData)
            XCTFail("Must not go here!")
        } catch {
            let requestError = error as? RequestError
            XCTAssertNotNil(requestError)
            XCTAssertEqual(requestError, RequestError.invalidURL)
        }
    }

    func test_givenNoRequestData_createRequestWithError() throws {
        configuration = APIConfiguration(baseURL: "https://xm.com")
        sut = QuestionSubmissionRequest(configuration)

        do {
            let requestData: Answer? = nil

            let _ = try sut.createRequest(requestData)
            XCTFail("Must not go here!")
        } catch {
            let requestError = error as? RequestError
            XCTAssertNotNil(requestError)
            XCTAssertEqual(requestError, RequestError.missingData)
        }
    }

    func test_validRequest() throws {
        configuration = APIConfiguration(baseURL: "https://xm.com")
        sut = QuestionSubmissionRequest(configuration)

        let requestData = Answer(id: 1, answer: "Answer")

        let request = try sut.createRequest(requestData)

        let url = request.url
        let expectedURL = URL(string: "https://xm.com/question/submit")!
        XCTAssertNotNil(url)
        XCTAssertEqual(request.url, expectedURL)
        XCTAssertEqual(request.httpMethod?.lowercased(), "post")
    }
}

//
//  XCTestCase+Combine.swift
//  XMSurveyTests
//
//  Created by Thinh on 6.11.2022.
//

import XCTest
import Combine

extension XCTestCase {
    func awaitResult<T: Publisher>(
        from publisher: T,
        timeout: TimeInterval = 2,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> Result<T.Output, Error> {
        var result: Result<T.Output, Error>?
        let expectation = expectation(description: "Awaiting publisher")

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    result = .failure(error)
                }

                expectation.fulfill()
            },
            receiveValue: { output in
                result = .success(output)
            }
        )

        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        return try XCTUnwrap(
            result,
            "There must be a result",
            file: file,
            line: line
        )
    }

    func awaitOutput<T: Publisher>(
        from publisher: T,
        timeout: TimeInterval = 1,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        let result = try awaitResult(from: publisher, timeout: timeout, file: file, line: line)

        switch result {
            case let .success(output): return output
            case let .failure(error): throw error
        }
    }

    func awaitError<T: Publisher>(
        from publisher: T,
        timeout: TimeInterval = 1,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> Error where T.Failure: Error {
        let result = try awaitResult(from: publisher, timeout: timeout, file: file, line: line)

        var err: Error?
        switch result {
            case .success:
                XCTFail("An error is expected")
                err = nil
            case let .failure(error):
                err = error
        }

        return try XCTUnwrap(err)
    }
}

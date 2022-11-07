//
//  File.swift
//  XMSurveyTests
//
//  Created by Thinh on 6.11.2022.
//

import Foundation
import XCTest

extension Data {
    public static func fromJSON(
        fileName: String,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> Data {

        let bundle = Bundle(for: TestBundleClass.self)
        let url = try XCTUnwrap(
            bundle.url(forResource: fileName, withExtension: "json"),
            "\(fileName).json not found",
            file: file,
            line: line
        )
        return try Data(contentsOf: url)
    }
}

private class TestBundleClass { }


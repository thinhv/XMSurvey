//
//  Question.swift
//  XMSurvey
//
//  Created by Thinh on 2.11.2022.
//

import Foundation

struct Question: Codable, Hashable {
    let id: Int // Can use phantom type here e.g, Id<Question>
    let question: String
}

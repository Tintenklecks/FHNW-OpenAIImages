//
//  OpenAI structures.swift
//  OpenAIImages
//
//  Created by Ingo Boehme on 21.12.22.
//

import Foundation

// MARK: - REQUEST BODY STRUCTURES -
// MARK: - ModerationBody

struct ModerationBody: Codable {
    let input: String
}

// MARK: - ImageBody

struct ImageBody: Codable {
    let prompt: String
    let n: Int
    let size: String
}

// MARK: - AIImages

struct AIImages: Codable {
    let created: Int
    let data: [Datum]
}

// MARK: - Datum

struct Datum: Codable {
    let url: String
}


// MARK: - Moderation
struct Moderation: Codable {
    let results: [ModerationResult]
}

// MARK: - Result
struct ModerationResult: Codable {
    let categories: ModerationCategories
}

// MARK: - Categories
struct ModerationCategories: Codable {
    let hate: Bool
    let hateThreatening: Bool
    let selfHarm: Bool
    let sexual: Bool
    let sexualMinors: Bool
    let violence: Bool
    let violenceGraphic: Bool

    enum CodingKeys: String, CodingKey {
        case hate = "hate"
        case hateThreatening = "hate/threatening"
        case selfHarm = "self-harm"
        case sexual = "sexual"
        case sexualMinors = "sexual/minors"
        case violence = "violence"
        case violenceGraphic = "violence/graphic"
    }
}

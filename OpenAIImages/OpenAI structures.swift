//
//  OpenAI structures.swift
//  OpenAIImages
//
//  Created by Ingo Boehme on 21.12.22.
//

import Foundation

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

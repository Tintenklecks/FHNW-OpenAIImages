//
//  OpenAI.API.swift
//  OpenAIImages
//
//  Created by Ingo Boehme on 22.12.22.
//

import Foundation

// MARK: - OpenAIAPI

enum OpenAIEndpoints {
    case generateImage(String, String)
    case moderation(String)

    var url: URL {
        switch self {
        case .generateImage:
            return URL(string: "https://api.openai.com/v1/images/generations")!
        case .moderation:
            return URL(string: "https://api.openai.com/v1/moderations")!
        }
    }

    var httpMethod: String {
        switch self {
        default: return "POST"
        }
    }

    var request: URLRequest {
        var localRequest = URLRequest(url: self.url)
        localRequest.httpMethod = self.httpMethod
        localRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        localRequest.setValue("Bearer \(Secret.apiKey)", forHTTPHeaderField: "Authorization")

        switch self {
        case .generateImage(let prompt, let size):
            let body = ImageBody(prompt: prompt, n: 1, size: size)
            localRequest.httpBody = try? JSONEncoder().encode(body)
            return localRequest
        case .moderation(let prompt):
            let body = ModerationBody(input: prompt)
            localRequest.httpBody = try? JSONEncoder().encode(body)
            return localRequest
        }
    }
}

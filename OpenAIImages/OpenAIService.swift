//
//  OpenAIService.swift
//  OpenAIImages
//
//  Created by Ingo Boehme on 15.12.22.
//

import Foundation

// MARK: - Secret

struct Secret {
    static var apiKey = "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"
}

// MARK: - OpenAIAPI

enum OpenAIAPI {
    case generateImage(String, String)

    var url: URL {
        switch self {
        case .generateImage:
            return URL(string: "https://api.openai.com/v1/images/generations")!
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
        }
    }
}

// MARK: - OpenAIService

class OpenAIService {
    
    func generateImage(prompt: String, size: String)  async throws{
        
        let request = OpenAIAPI.generateImage(prompt, size).request
        
        let (data, response) = try await URLSession.shared.data(for: request)

        #warning("HIER GEHTS WEITER")
    }
    
    
}

// MARK: - ImageBody

struct ImageBody: Codable {
    let prompt: String
    let n: Int
    let size: String
}

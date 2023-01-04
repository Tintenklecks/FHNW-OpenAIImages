//
//  OpenAIService.swift
//  OpenAIImages
//
//  Created by Ingo Boehme on 15.12.22.
//

import Foundation

// MARK: - OpenAIAPI

enum OpenAIAPI {
    case generateImage(String, String)
    case moderate(String)

    var url: URL {
        switch self {
        case .generateImage:
            return URL(string: "https://api.openai.com/v1/images/generations")!
        case .moderate:
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
        case .moderate(let prompt):
            let body = ModerationBody(input: prompt)
            localRequest.httpBody = try? JSONEncoder().encode(body)
            return localRequest
        }
    }
}

// MARK: - OpenAIService

class OpenAIService {
    static func generateImage(prompt: String, size: String,
                              onSuccess: @escaping (AIImages) -> (),
                              onError: @escaping (String) -> ())
    {
        let request = OpenAIEndpoints.generateImage(prompt, size).request
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let response = response as? HTTPURLResponse {
                if response.statusCode >= 300 {
                    onError("Status code \(response.statusCode)")
                    return
                }
            }
            
            if let error {
                onError("Error \(error.localizedDescription)")
                return
            }
            
            guard let data else {
                onError("No data available")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AIImages.self, from: data)
                onSuccess(result)
            } catch {
                print(error.localizedDescription)
            }
        }
        .resume()
    }
    
    static func generateImage(prompt: String, size: String, completion: @escaping (Result<AIImages, NetworkError>) -> ()) {
        let request = OpenAIEndpoints.generateImage(prompt, size).request
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let response = response as? HTTPURLResponse {
                if response.statusCode >= 300 {
                    completion(.failure(.httpError(response.statusCode)))
                    return
                }
            }
            
            if let error {
                completion(.failure(.misc(error.localizedDescription)))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AIImages.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.misc(error.localizedDescription)))
            }
        }
        .resume()
    }
    
    static func generateImage(prompt: String, size: String) async throws -> AIImages {
        let request = OpenAIEndpoints.generateImage(prompt, size).request
        let result = try await NetworkService.load(from: request, convertTo: AIImages.self)
        return result
    }
    
    static func getModeration(prompt: String) async throws -> Moderation {
        let request = OpenAIEndpoints.moderation(prompt).request
        let result = try await NetworkService.load(from: request, convertTo: Moderation.self)
        return result
    }


    static func checkWords(prompt: String) async throws -> Bool {
        let request = OpenAIAPI.moderate(prompt).request
        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode >= 300
        {
            throw NetworkError.httpError(httpResponse.statusCode)
        }

        let moderation = try JSONDecoder().decode(Moderation.self, from: data)
        guard let entry = moderation.results.first?.categories else {
            return false
        }

        return !(entry.hate || entry.hateThreatening ||
            entry.selfHarm || entry.sexual ||
            entry.sexualMinors || entry.violence ||
            entry.violenceGraphic)
    }
}

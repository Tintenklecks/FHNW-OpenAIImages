//
//  OpenAIService.swift
//  OpenAIImages
//
//  Created by Ingo Boehme on 15.12.22.
//

import Foundation


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

}

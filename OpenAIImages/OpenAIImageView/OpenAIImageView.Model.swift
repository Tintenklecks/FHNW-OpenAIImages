//
//  OpenAIImageView.Model.swift
//  OpenAIImages
//
//  Created by Ingo Boehme on 15.12.22.
//

import Foundation

extension OpenAIImageView {
    class Model {
        func checkModeration(prompt: String) async throws -> Bool {
            let result = try await OpenAIService.getModeration(prompt: prompt)

            if let cat = result.results.first?.categories {
                let forbidden =
                    cat.violenceGraphic || cat.violence || cat.sexualMinors || cat.sexual || cat.selfHarm || cat.hateThreatening || cat.hate

                return !forbidden
            }
            throw NetworkError.noData
        }

        enum OpenAIError: Error {
            case forbidden
        }

        func generateImage(prompt: String, size: String) async throws -> URL {
            guard try await checkModeration(prompt: prompt) else {
                throw OpenAIError.forbidden
            }

            let result = try await OpenAIService.generateImage(prompt: prompt, size: size)

            if let urlString = result.data.first?.url,
               let url = URL(string: urlString)
            {
                return url
            }

            throw NetworkError.noData
        }
    }
}

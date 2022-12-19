//
//  OpenAIImageView.Model.swift
//  OpenAIImages
//
//  Created by Ingo Boehme on 15.12.22.
//

import Foundation

extension OpenAIImageView {
    class Model {
        var prompt: String = "Roter Ferrari"
        var size: ImageSize = .small

//        func fetch(completionHandler: @escaping (Result<ModelData, ModelError>) -> Void) {
//            completionHandler(.failure(.modelError))
//
//            let variable = ModelData()
//            completionHandler(.success(variable))
//        }
    }
}

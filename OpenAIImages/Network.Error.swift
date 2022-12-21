//
//  Network.Error.swift
//  OpenAIImages
//
//  Created by Ingo Boehme on 21.12.22.
//

import Foundation
// MARK: - NetworkError

enum NetworkError: Error {
    case decoding
    case internet
    case noData
    case httpError(Int)
    case misc(String)
}



//
//  OpenAIImagesApp.swift
//  OpenAIImages
//
//  Created by Ingo Boehme on 15.12.22.
//

import SwiftUI

@main
struct OpenAIImagesApp: App {
    init() {
        Task {
            do {
                let isOK = try await OpenAIService.checkWords(prompt: "Blumen")
                print(isOK ? "ALLES OK *****" : "NIX DA *****")
            } catch {}
        }

//        Task {
//            do {
//                let images = try await OpenAIService.generateImage(prompt: "Blumen", size: "256x256")
//                for url in images.data {
//                    print(url)
//                }
//            } catch let error as NetworkError {
//                switch error {
//                case .decoding: print("Error \(error.localizedDescription)")
//                case .internet: print("Error \(error.localizedDescription)")
//                case .noData: print("Error \(error.localizedDescription)")
//                case .httpError(let code): print("HTTP Error \(code)")
//                case .misc(let text): print("MISC Error \(text)")
//                }
//            }
//        }

//        OpenAIService.generateImage(prompt: "Blumen Stil von salvadore Dali", size: "256x256") { result in
//            switch result {
//            case .success(let images):
//                for url in images.data {
//                    print(url)
//                }
//            case .failure(let error):
//                print("\(error.localizedDescription)")
//            }
//        }

//        OpenAIService.generateImage(
//            prompt: "Blumen Stil von salvadore Dali",
//            size: "256x256") { images in
//            for url in images.data {
//                print(url)
//            }
//        } onError: { error in
//            print(error)
//        }
    }

    var body: some Scene {
        WindowGroup {
            OpenAIImageView()
        }
    }
}

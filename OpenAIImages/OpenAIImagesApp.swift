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
        OpenAIService.generateImage(
            prompt: "Blumen Stil von salvadore Dali",
            size: "256x256") { images in
            for url in images.data {
                print(url)
            }
        } onError: { error in
            print(error)
        }

    }

    var body: some Scene {
        
        
        WindowGroup {
            OpenAIImageView()
        }
    }
}

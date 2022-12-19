//
//  OpenAIImageView.Viewmodel.swift
//  OpenAIImages
//
//  Created by Ingo Boehme on 15.12.22.
//

import Foundation

extension OpenAIImageView {
    enum ImageSize: Int, CaseIterable {
        case small = 256
        case medium = 512
        case large = 1024
        
        var name: String {
            return "\(self.rawValue)x\(self.rawValue)"
        }
    }
    
    class ViewModel: ObservableObject {
        @Published var imageUrl: URL?
        @Published var prompt: String = "Roter Ferrari"
        @Published var size: ImageSize = .small

        var model = Model()
        
        func renderImage() {
            
            
            
        }
    }
}

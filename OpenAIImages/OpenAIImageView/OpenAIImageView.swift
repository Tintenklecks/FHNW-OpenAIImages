//
//  ContentView.swift
//  OpenAIImages
//
//  Created by Ingo Boehme on 15.12.22.
//

import SwiftUI

// MARK: - OpenAIImageView

struct OpenAIImageView: View {
    @StateObject var viewModel = ViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Description of picture").bold()
            TextField("", text: $viewModel.prompt, axis: .vertical)
                .textFieldStyle(.roundedBorder)

            Text("Picture size:").bold()
            Picker("", selection: $viewModel.size) {
                ForEach(ImageSize.allCases, id: \.self) { size in
                    Text(size.name)
                        .tag(size)
                }
            }
            .pickerStyle(.segmented)
            
            HStack{
                Button("Check wording") {
                    
                }
                .buttonStyle(.bordered)
                Button("Generate image") {
                    viewModel.renderImage()

                }.buttonStyle(.borderedProminent)
            }
            AsyncImage(url: viewModel.imageUrl)
            
        }
        .padding()
    }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OpenAIImageView()
    }
}

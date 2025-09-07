//
//  ImageExtensions.swift
//  RickAndMorty
//
//  Created by Gabriel Marson on 07/09/25.
//

import SwiftUI

extension Image {
    
    static func fromURL(_ urlString: String,
                        placeholder: Image = .placeHolder,
                        errorImage: Image = .notFound) -> some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .empty:
                placeholder
                    .resizable()
            case .success(let image):
                image
                    .resizable()
            case .failure(_):
                errorImage
                    .resizable()
            @unknown default:
                errorImage
                    .resizable()
            }
        }
    }
    
}

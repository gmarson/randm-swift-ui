//
//  CharacterView.swift
//  RickAndMorty
//
//  Created by Gabriel Marson on 06/09/25.
//

import SwiftUI

struct CharacterView: View {
    
    @State var character: RMCharacter
    
    var body: some View {
        
        HStack {
            Image
                .fromURL(character.image)
                .frame(width: 150)
            
            VStack(alignment: .leading) {
                Text(character.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.softWhite)
                
                HStack {
                    
                    Image(systemName: "circle.fill")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(circleColor)
                        .frame(width: 10, height: 10)
                        
                        
                    Text("\(character.lifeStatus.rawValue) - \(character.species)")
                        .foregroundStyle(Color.softWhite)
                }
            
                Text("Last Known Location:")
                    .foregroundStyle(.gray)
                Text(character.location.name)
                    .foregroundStyle(Color.softWhite)
                    .padding(.bottom)
                
                if let epNumber = character.firstEpisodeEncounter {
                    Text("First seen in:")
                        .foregroundStyle(.gray)
                    Text("Episode \(epNumber)")
                        .foregroundStyle(Color.softWhite)
                        .padding(.bottom)
                }
            }
            .padding(.leading)
            .padding(.trailing)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.cellBackground)
        
    }
    
    private var circleColor: Color {
        switch character.lifeStatus {
        case .alive:
            return .green
        case .dead:
            return .red
        case .unowned:
            return .gray
        }
    }
    
    
}



#Preview {
    CharacterView(character: .morty)
        .frame(width: 360, height: 210)
        
}

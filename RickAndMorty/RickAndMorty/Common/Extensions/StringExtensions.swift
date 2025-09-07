//
//  StringExtensions.swift
//  RickAndMorty
//
//  Created by Gabriel Marson on 07/09/25.
//

extension String {
    
    var digitsAfterLastSlash: String? {
        guard let lastComponent = self.split(separator: "/").last else {
            return nil
        }
        let digits = lastComponent.filter { $0.isNumber }
        return digits.isEmpty ? nil : digits
    }
    
}

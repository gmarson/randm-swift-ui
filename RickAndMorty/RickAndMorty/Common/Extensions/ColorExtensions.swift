//
//  ColorExtensions.swift
//  RickAndMorty
//
//  Created by Gabriel Marson on 06/09/25.
//

import SwiftUI

extension Color {
    
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let length = hexSanitized.count
        let r, g, b, a: UInt64

        switch length {
        case 6: // RGB (no alpha)
            (r, g, b, a) = (
                (rgb & 0xFF0000) >> 16,
                (rgb & 0x00FF00) >> 8,
                rgb & 0x0000FF,
                255
            )
        case 8: // RGBA
            (r, g, b, a) = (
                (rgb & 0xFF000000) >> 24,
                (rgb & 0x00FF0000) >> 16,
                (rgb & 0x0000FF00) >> 8,
                rgb & 0x000000FF
            )
        default:
            return nil
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
}

//
//  NSColor+Extension.swift
//  midget-widgetExtension
//
//  Created by Arthur Fontaine on 28/09/2023.
//

import SwiftUI

extension NSColor {

    var hexString: String {
        let red = Int(round(self.redComponent * 0xFF))
        let green = Int(round(self.greenComponent * 0xFF))
        let blue = Int(round(self.blueComponent * 0xFF))
        let hexString = NSString(format: "#%02X%02X%02X", red, green, blue)
        return hexString as String
    }
    
    var lighterColor: NSColor {
        let factor: CGFloat = 1.2 // Adjust this factor to make it lighter or darker
        let adjustedRed = min(self.redComponent * factor, 1.0)
        let adjustedGreen = min(self.greenComponent * factor, 1.0)
        let adjustedBlue = min(self.blueComponent * factor, 1.0)
        return NSColor(red: adjustedRed, green: adjustedGreen, blue: adjustedBlue, alpha: self.alphaComponent)
    }

    var darkerColor: NSColor {
        let factor: CGFloat = 0.8 // Adjust this factor to make it lighter or darker
        let adjustedRed = max(self.redComponent * factor, 0.0)
        let adjustedGreen = max(self.greenComponent * factor, 0.0)
        let adjustedBlue = max(self.blueComponent * factor, 0.0)
        return NSColor(red: adjustedRed, green: adjustedGreen, blue: adjustedBlue, alpha: self.alphaComponent)
    }

    var shades: [NSColor] {
        var shadesArray: [NSColor] = []
        
        var currentColor = self.darkerColor
        for _ in 1...10 {
            shadesArray.append(currentColor)
            currentColor = currentColor.darkerColor
        }

        shadesArray.append(self) // Add the original color

        currentColor = self.lighterColor
        for _ in 1...10 {
            shadesArray.append(currentColor)
            currentColor = currentColor.lighterColor
        }

        return shadesArray
    }
    
    func contrastRatio(with colorB: NSColor) -> CGFloat {
        let luminanceA = self.relativeLuminance()
        let luminanceB = colorB.relativeLuminance()

        let contrast = (max(luminanceA, luminanceB) + 0.05) / (min(luminanceA, luminanceB) + 0.05)

        return contrast
    }

    private func relativeLuminance() -> CGFloat {
        let red = self.redComponent <= 0.03928 ? self.redComponent / 12.92 : pow((self.redComponent + 0.055) / 1.055, 2.4)
        let green = self.greenComponent <= 0.03928 ? self.greenComponent / 12.92 : pow((self.greenComponent + 0.055) / 1.055, 2.4)
        let blue = self.blueComponent <= 0.03928 ? self.blueComponent / 12.92 : pow((self.blueComponent + 0.055) / 1.055, 2.4)

        return (0.2126 * red) + (0.7152 * green) + (0.0722 * blue)
    }

}

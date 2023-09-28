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

}

//
//  MediaRemoteController+Extension.swift
//  midget-widgetExtension
//
//  Created by Arthur Fontaine on 28/09/2023.
//

import Foundation
import SwiftUI

extension MediaRemoteController.MediaInfo {
    
    var artworkColor: NSColor? {
        if let artworkData = self.artworkData {
            return averageColor(data: artworkData)
        }
        
        return nil
    }
    
}

//
//  UIImage+Extension.swift
//  midget-widgetExtension
//
//  Created by Arthur Fontaine on 28/09/2023.
//

import Foundation
import SwiftUI

// Inspired by https://gist.github.com/bbaars/0851c25df14941becc7a0307e41cf716#file-average-color-002-swift
func averageColor(data: Data) -> NSColor? {
    // convert our image to a Core Image Image
    guard let inputImage = CIImage(data: data) else { return nil }

    // Create an extent vector (a frame with width and height of our current input image)
    let extentVector = CIVector(x: inputImage.extent.origin.x,
                                y: inputImage.extent.origin.y,
                                z: inputImage.extent.size.width,
                                w: inputImage.extent.size.height)

    // create a CIAreaAverage filter, this will allow us to pull the average color from the image later on
    guard let filter = CIFilter(name: "CIAreaAverage",
                              parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
    guard let outputImage = filter.outputImage else { return nil }

    // A bitmap consisting of (r, g, b, a) value
    var bitmap = [UInt8](repeating: 0, count: 4)
    let context = CIContext(options: [.workingColorSpace: kCFNull!])

    // Render our output image into a 1 by 1 image supplying it our bitmap to update the values of (i.e the rgba of the 1 by 1 image will fill out bitmap array
    context.render(outputImage,
                   toBitmap: &bitmap,
                   rowBytes: 4,
                   bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                   format: .RGBA8,
                   colorSpace: nil)

    // Convert our bitmap images of r, g, b, a to a UIColor
    return NSColor(red: CGFloat(bitmap[0]) / 255,
                   green: CGFloat(bitmap[1]) / 255,
                   blue: CGFloat(bitmap[2]) / 255,
                   alpha: CGFloat(bitmap[3]) / 255)
}

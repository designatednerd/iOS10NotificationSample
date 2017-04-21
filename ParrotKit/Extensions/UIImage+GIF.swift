//
//  UIImage+GIF.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 9/1/16.
//  Copyright © 2016 Designated Nerd Software. All rights reserved.
//

import ImageIO
import UIKit


//Lots of fun stuff upgraded from https://github.com/bahlo/SwiftGif
extension UIImage {
    
    private static func dns_animatedImage(with source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        
        // Fill arrays
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.dns_delayForImage(at: i, source: source)
            let delayMilliseconds = Int(delaySeconds * 1000)
            delays.append(delayMilliseconds)
        }
        
        // Calculate full duration
        let duration = delays.reduce(0) {
            delay, exsitingDuration in
            return exsitingDuration + delay
        }
        
        // Even out the frames
        let gcd = GreatestCommonDenominator.in(array: delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[i])
            frameCount = Int(delays[i] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        // Actually animate
        let durationInSeconds = Double(duration) / 1000.0
        let animation = UIImage.animatedImage(with: frames,
                                              duration: durationInSeconds)
        
        return animation
    }
    
    private static func dns_delayForImage(at index: Int,
                                  source: CGImageSource!) -> Double {
        let minimumDelay = 0.1
        
        // Get dictionaries
        guard let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) else {
            assertionFailure("Couldn't get properties for gif")            
            return minimumDelay
        }
        let gifProperties: CFDictionary = unsafeBitCast(CFDictionaryGetValue(cfProperties,
                                                                            UnsafeRawPointer(Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque())),
                                                        to: CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                                        UnsafeRawPointer(Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque())),
                                                   to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             UnsafeRawPointer(Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque())),
                                        to: AnyObject.self)
        }
        
        guard let delay = delayObject as? Double else {
            //Just return the minimum and bail. 
            return minimumDelay
        }
        return delay

    }
    
    static func dns_gifWith(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            assertionFailure("Source for the image does not exist")
            return nil
        }
        
        return UIImage.dns_animatedImage(with: source)
    }
    
    static func dns_gifWith(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                assertionFailure("No gif named \"\(name)\" in the main bundle")
                return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            assertionFailure("No data for gif named \"\(name)\"")
            return nil
        }
        
        return dns_gifWith(data: imageData)
    }
}

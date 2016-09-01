//
//  PartyParrot.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 9/1/16.
//  Copyright © 2016 Designated Nerd Software. All rights reserved.
//

import Foundation
import UIKit

struct PartyParrot {
    let name: String
    let gif: ParrotGif
    
    enum ParrotJSONKey: String {
        case
        name,
        image_name
    }
    
    init?(userInfo: [AnyHashable : Any]) {
        guard
            let name = userInfo[ParrotJSONKey.name.rawValue] as? String,
            let imageName = userInfo[ParrotJSONKey.image_name.rawValue] as? String,
            let gif = ParrotGif(rawValue: imageName) else {
                return nil
        }
        
        self.name = name
        self.gif = gif
    }
}

enum ParrotGif: String {
    case
    aussieparrot,
    boredparrot,
    chillparrot,
    dealwithitparrot,
    fastparrot,
    fiestaparrot,
    gothparrot,
    icecreamparrot = "ice-cream-parrot",
    oldtimeyparrot,
    parrot,
    parrotcop,
    parrotwave1,
    parrotwave2,
    parrotwave3,
    parrotwave4,
    parrotwave5,
    parrotwave6,
    parrotwave7,
    partyparrot,
    slowparrot
    
    func animated() -> UIImage {
        guard let gif = UIImage.dns_gifWith(name: self.rawValue) else {
            fatalError("Could not load gif for \(self.rawValue)")
        }
        
        return gif
    }
    
    static func wave() -> [UIImage] {
        return [
            self.parrotwave1.animated(),
            self.parrotwave2.animated(),
            self.parrotwave3.animated(),
            self.parrotwave4.animated(),
            self.parrotwave5.animated(),
            self.parrotwave6.animated(),
            self.parrotwave7.animated(),
        ]
    }
}

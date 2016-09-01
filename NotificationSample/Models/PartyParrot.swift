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
    
    func animated() -> UIImage? {
        return UIImage.dns_gifWith(name: self.rawValue)
    }
}

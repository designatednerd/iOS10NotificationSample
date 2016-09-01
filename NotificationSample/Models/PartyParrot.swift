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
    
    init(name: String, gif: ParrotGif) {
        self.name = name
        self.gif = gif
    }
    
    init?(userInfo: [AnyHashable : Any]) {
        guard
            let name = userInfo[ParrotJSONKey.name.rawValue] as? String,
            let imageName = userInfo[ParrotJSONKey.image_name.rawValue] as? String,
            let gif = ParrotGif(rawValue: imageName) else {
                return nil
        }
        
        self.init(name: name, gif: gif)
    }
    
    func toUserInfo() -> [String: String] {
        var userInfo = [String : String]()
        
        userInfo[ParrotJSONKey.name.rawValue] = self.name
        userInfo[ParrotJSONKey.image_name.rawValue] = self.gif.rawValue
        
        return userInfo
    }
    
    static func nonstandardParrots() -> [PartyParrot] {
        return [
            PartyParrot(name: "Aussie Parrot", gif: .aussieparrot),
            PartyParrot(name: "Bored Parrot", gif: .boredparrot),
            PartyParrot(name: "Chill Parrot", gif: .chillparrot),
            PartyParrot(name: "Deal With It Parrot", gif: .dealwithitparrot),
            PartyParrot(name: "Fast Parrot", gif: .fastparrot),
            PartyParrot(name: "Fiesta Parrot", gif: .fiestaparrot),
            PartyParrot(name: "Goth Parrot", gif: .gothparrot),
            PartyParrot(name: "Ice Cream Party Parrot", gif: .icecreamparrot),
            PartyParrot(name: "Old-Timey Parrot", gif: .oldtimeyparrot),
            PartyParrot(name: "Cop Parrot", gif: .parrotcop),
            PartyParrot(name: "Slow Parrot", gif: .slowparrot),
        ]
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



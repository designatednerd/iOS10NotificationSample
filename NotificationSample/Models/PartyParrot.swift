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
    let imageName: String
    
    enum ParrotJSONKey: String {
        case
        name,
        image_name
    }
    
    var image: UIImage? {
        return UIImage(named: self.imageName)
    }
    
    init?(userInfo: [AnyHashable : Any]) {
        guard
            let name = userInfo[ParrotJSONKey.name.rawValue] as? String,
            let imageName = userInfo[ParrotJSONKey.image_name.rawValue] as? String else {
                return nil
        }
        
        self.name = name
        self.imageName = imageName        
    }
}

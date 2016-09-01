//
//  Party.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 9/1/16.
//  Copyright © 2016 Designated Nerd Software. All rights reserved.
//

import Foundation

struct Party {
    
    static var current = Party()
    
    var parrots = [PartyParrot]()
    
    mutating func add(parrot parrotToAdd: PartyParrot) {
        self.parrots.append(parrotToAdd)
    }
    
    mutating func block(parrot parrotToBlock: PartyParrot) {
        self.parrots = self.parrots.filter() {
                            parrot in
                            guard (parrot.name != parrotToBlock.name
                                && parrot.gif != parrotToBlock.gif) else {
                                return false
                            }
                        
                            return true
                        }
    }
}

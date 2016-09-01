//
//  ParrotAPIController.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 9/1/16.
//  Copyright © 2016 Designated Nerd Software. All rights reserved.
//

import Foundation

struct ParrotAPIController {

    static func sendDeviceTokenToOurServer(token: Data) {
        //Hey, this is an example. It doesn't actually have to do anything!    
    }
    
    static func getInfo(for parrot: PartyParrot, completion: (Void) -> (Void)) {
        //Pretend we got some information and updated the parrot. 
        completion()
    }
    
    static func add(parrot: PartyParrot) {
        //Add parrot as friend
    }
    
    static func block(parrot: PartyParrot) {
        //block parrot.
    }
}

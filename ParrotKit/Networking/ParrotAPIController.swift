//
//  ParrotAPIController.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 9/1/16.
//  Copyright © 2016 Designated Nerd Software. All rights reserved.
//

import Foundation

public struct ParrotAPIController {

    public static func sendDeviceTokenToOurServer(token: Data) {
        //Hey, this is an example. It doesn't actually have to do anything!    
    }
    
    public static func getInfo(for parrot: PartyParrot, completion: (Void) -> (Void)) {
        //Pretend we got some information and updated the parrot. 
        completion()
    }
    
    public static func add(_ parrot: PartyParrot) {
        //Add parrot as friend
        Friends.mine.add(parrot)
    }
    
    public static func block(_ parrot: PartyParrot) {
        //block parrot.
        Friends.mine.block(parrot)
        Party.current.block(parrot)
    }
}

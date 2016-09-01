//
//  ParrotAction.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 9/1/16.
//  Copyright © 2016 Designated Nerd Software. All rights reserved.
//

import Foundation

enum ParrotAction: String {
    case
    block = "com.example.action.block",
    add = "com.example.action.add",
    partyWith = "com.example.action.partywith"
    
    func performWith(parrot: PartyParrot) {
        switch self {
        case .add:
            ParrotAPIController.add(parrot: parrot)
        case .block:
            ParrotAPIController.block(parrot: parrot)
        case .partyWith:
            Party.current.add(parrot: parrot)
        }
    }
}

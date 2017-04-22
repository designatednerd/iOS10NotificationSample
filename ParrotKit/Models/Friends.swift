//
//  Friends.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 4/21/17.
//  Copyright © 2017 Designated Nerd Software. All rights reserved.
//

import Foundation

public struct Friends {

    public static var mine = Friends()
    private init() {
        self.parrots = UserDefaultsWrapper.storedFriends()
    }
    
    public var parrots: [PartyParrot]
    
    private func postUpdateNotification() {
        NotificationCenter
            .default
            .post(name: .FriendsUpdated,
                  object: nil)
    }

    public mutating func reloadFromDefaults() {
        self.parrots = UserDefaultsWrapper.storedFriends()
        self.postUpdateNotification()
    }
    
    public mutating func add(_ parrotToAdd: PartyParrot) {
        self.parrots.append(parrotToAdd)
        UserDefaultsWrapper.storeFriends(self.parrots)
        self.postUpdateNotification()
    }
    
    public mutating func block(_ parrotToBlock: PartyParrot) {
        self.parrots = self.parrots.filter { $0 != parrotToBlock }
        UserDefaultsWrapper.storeFriends(self.parrots)
        self.postUpdateNotification()
    }
    
}

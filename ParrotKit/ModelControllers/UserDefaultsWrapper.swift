//
//  UserDefaultsWrapper.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 4/22/17.
//  Copyright © 2017 Designated Nerd Software. All rights reserved.
//

import Foundation

public struct UserDefaultsWrapper {
    
    private enum UserDefaultsKey: String {
        case
        friends = "com.designatednerd.iOS10Push.friends",
        party = "com.designatednerd.iOS10Push.party"
    }

    private static var cachedDefaults: UserDefaults?
    private static func sharedDefaults() -> UserDefaults {
        if let cached = self.cachedDefaults {
            return cached
        }
        
        guard let defaults = UserDefaults(suiteName: "group.com.designatednerd.iOS10Push") else {
            fatalError("Could not create shared defaults!")
        }
        
        self.cachedDefaults = defaults
        return defaults
    }
    
    // MARK: - Storage & Retrieval 
    
    private static func store(parrots: [PartyParrot], for key: UserDefaultsKey) {
        let parrotDicts = parrots.map { $0.userInfo }
        self.sharedDefaults().set(parrotDicts, forKey: key.rawValue)
    }
    
    private static func retrieve(parrotsForKey key: UserDefaultsKey) -> [PartyParrot] {
        guard let dicts = self.sharedDefaults().value(forKey: key.rawValue) as? [[AnyHashable: Any]] else {
            return [PartyParrot]()
        }
        
        let parrots = dicts.flatMap { PartyParrot(userInfo: $0) }
        return parrots
    }
    
    // MARK: - Friends
    
    public static func storedFriends() -> [PartyParrot] {
        return self.retrieve(parrotsForKey: .friends)
    }

    public static func storeFriends(_ friends: [PartyParrot]) {
        self.store(parrots: friends, for: .friends)
    }
    
    //MARK: - Party
    
    public static func storedParty() -> [PartyParrot] {
        return self.retrieve(parrotsForKey: .party)
    }
    
    public static func storeParty(_ party: [PartyParrot]) {
        self.store(parrots: party, for: .party)
    }
    
}

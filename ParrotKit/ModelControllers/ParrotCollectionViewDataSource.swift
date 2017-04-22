//
//  ParrotCollectionViewDataSource.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 4/20/17.
//  Copyright © 2017 Designated Nerd Software. All rights reserved.
//

import UIKit

class ParrotCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var parrots: [PartyParrot] {
        fatalError("You'd think this would be a good place for a protocol, but apparently protocols and objective-c interop make all child deities cry, so subclasses must override this var.")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        debugPrint("Parrots: \(self.parrots.count)")
        return self.parrots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParrotCollectionViewCell.identifier, for: indexPath) as? ParrotCollectionViewCell else {
            fatalError("This is not my beautiful cell!")
        }
        
        let parrot = self.parrots[indexPath.item]
        cell.parrot = parrot
        
        return cell
    }
}

class PartyCollectionViewDataSource: ParrotCollectionViewDataSource {

    override var parrots: [PartyParrot] {
        return Party.current.parrots
    }
}

class FriendsCollectionViewDataSource: ParrotCollectionViewDataSource {

    override var parrots: [PartyParrot] {
        return Friends.mine.parrots
    }
    
}

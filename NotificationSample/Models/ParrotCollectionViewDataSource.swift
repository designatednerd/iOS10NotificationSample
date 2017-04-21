//
//  ParrotCollectionViewDataSource.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 4/20/17.
//  Copyright © 2017 Designated Nerd Software. All rights reserved.
//

import UIKit

class ParrotCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Party.current.parrots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParrotCollectionViewCell.identifier, for: indexPath) as? ParrotCollectionViewCell else {
            fatalError("This is not my beautiful cell!")
        }
        
        let parrot = Party.current.parrots[indexPath.item]
        cell.parrot = parrot
        
        return cell
    }
}

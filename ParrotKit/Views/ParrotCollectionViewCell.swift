//
//  ParrotCollectionViewCell.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 4/20/17.
//  Copyright © 2017 Designated Nerd Software. All rights reserved.
//

import UIKit

public class ParrotCollectionViewCell: UICollectionViewCell {

    public static let identifier = "ParrotCell"
    
    @IBOutlet private var imageView: UIImageView!
    
    public var parrot: PartyParrot? {
        didSet {
            imageView.image = parrot?.gif.animated
        }
    }
}

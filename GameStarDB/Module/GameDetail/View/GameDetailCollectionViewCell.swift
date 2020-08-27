//
//  GameDetailCollectionViewCell.swift
//  GameStarDB
//
//  Created by Roman on 29.07.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import typealias Reusable.NibReusable
import UIKit

class GameDetailCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet var gameDetailImageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()

        gameDetailImageView.image = UIImage()
    }

}

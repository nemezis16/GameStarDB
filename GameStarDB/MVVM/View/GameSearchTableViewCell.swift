//
//  GameSearchTableViewCell.swift
//  GameStarDB
//
//  Created by Roman Osadchuk on 12.01.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import UIKit

class GameSearchTableViewCell: UITableViewCell {

    @IBOutlet var gameImageView: UIImageView!
    @IBOutlet var gameTitleLabel: UILabel!
    @IBOutlet var gameGenraLabel: UILabel!
    @IBOutlet var gameRatingLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        
        gameImageView.image = UIImage()
        gameTitleLabel.text = ""
        gameGenraLabel.text = ""
        gameRatingLabel.text = ""
    }

}

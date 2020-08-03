//
//  GameSearchTableViewCell.swift
//  GameStarDB
//
//  Created by Roman Osadchuk on 12.01.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import typealias Reusable.NibReusable
import UIKit

class GameSearchTableViewCell: UITableViewCell, NibReusable {
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

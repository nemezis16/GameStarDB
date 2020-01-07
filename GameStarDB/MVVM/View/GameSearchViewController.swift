//
//  GameSearchViewController.swift
//  GameStarDB
//
//  Created by Roman Osadchuk on 06.01.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import UIKit

class GameSearchViewController: UIViewController {

    let gameSearchViewModel = GameSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gameSearchViewModel.requestData()
    }

}

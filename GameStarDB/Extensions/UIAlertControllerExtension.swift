//
//  UIAlertControllerExtension.swift
//  GameStarDB
//
//  Created by Roman Osadchuk on 12.01.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func alertWith(message: String, completion: ((UIAlertAction) -> Void)? = nil ) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: completion))
        return alert
    }
    
}

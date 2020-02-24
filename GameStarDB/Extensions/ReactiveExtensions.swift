//
//  ReactiveExtensions.swift
//  GameStarDB
//
//  Created by Roman Osadchuk on 11.01.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    
    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    public var isAnimating: Binder<Bool> {
        return Binder(self.base, binding: { (vc, active) in
            if active {
//                vc.startAnimating()
            } else {
//                vc.stopAnimating()
            }
        })
    }
    
}



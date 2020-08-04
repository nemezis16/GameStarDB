//
//  GameDetailViewController.swift
//  GameStarDB
//
//  Created by Roman on 20.04.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import Reusable
import RxDataSources

class GameDetailViewController: UIViewController, StoryboardView, StoryboardBased {
    private typealias Action = GameDetailReactor.Action
    var disposeBag = DisposeBag()

    @IBOutlet var collectionView: UICollectionView!

    private let dataSource = RxCollectionViewSectionedReloadDataSource <GameDetailReactor.SectionType> (configureCell: {  _, collectionView, indexPath, item in
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: GameDetailCollectionViewCell.self)
        return cell
    })

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bind(reactor: GameDetailReactor) {
        
    }
}
//
//extension GameDetailViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        5
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameDetailCollectionViewCell", for: indexPath)
//        return cell
//    }
//}
//
//extension GameDetailViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        collectionView.bounds.size
//    }
//}

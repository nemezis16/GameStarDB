//
//  GameDetailViewController.swift
//  GameStarDB
//
//  Created by Roman on 20.04.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import RxDataSources
import Reusable

class GameDetailViewController: UIViewController, StoryboardBased {
    @IBOutlet var collectionView: UICollectionView!

    private let dataSource = RxCollectionViewSectionedReloadDataSource <GameDetailReactor.SectionType> (configureCell: {  _, collectionView, indexPath, item in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameDetailCollectionViewCell", for: indexPath)
        return cell
    })

    override func viewDidLoad() {
        super.viewDidLoad()
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

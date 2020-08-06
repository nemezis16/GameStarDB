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
        cell.gameDetailImageView.loadImage(fromURL: item.replacingOccurrences(of: "//", with: "http://")
                                                        .replacingOccurrences(of: "t_thumb", with: "t_1080p"))
        return cell
    })

    override func viewDidLoad() {
        super.viewDidLoad()

//        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    func bind(reactor: GameDetailReactor) {
        let state = reactor.state.asDriver(onErrorJustReturn: reactor.initialState)
        state.map { $0.dataSource }.distinctUntilChanged().drive(collectionView.rx.items(dataSource: self.dataSource)).disposed(by: disposeBag)

    }
}

extension GameDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

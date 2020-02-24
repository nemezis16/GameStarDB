//
//  GameSearchViewController.swift
//  GameStarDB
//
//  Created by Roman Osadchuk on 06.01.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GameSearchViewController: UIViewController {

    let gameSearchViewModel = GameSearchViewModel()
    var gameItems = PublishSubject<[GameListItem]>()
    @IBOutlet var gameSearchTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var querySubject = PublishSubject<String>()

    
    let disposeBag = DisposeBag()

//MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupBingings()
        self.gameSearchViewModel.requestData(data: "potter")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCells()
    }

//MARK: Private

    func setupBingings() {
        
        // Loading
        gameSearchViewModel.loading.bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        
        // Error
        gameSearchViewModel
        .error
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { (error) in
            var messageError: String!
            switch error {
            case .internetError(let message):
                messageError = message
            case .serverMessage(let message):
                messageError = message
            }
            self.present(UIAlertController.alertWith(message: messageError), animated: true)
        })
        .disposed(by: disposeBag)
        
        // GameList
        gameSearchViewModel
        .gameList
        .observeOn(MainScheduler.instance)
        .bind(to: gameItems)
        .disposed(by: disposeBag)
        
        let results = searchBar.rx.text.orEmpty
        .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
        .distinctUntilChanged()
        .flatMapLatest { query in
            Observable.just(query).asDriver(onErrorJustReturn: query)
        }.observeOn(MainScheduler.instance)

        results.bind(to: querySubject).disposed(by: disposeBag)

//        let results = self.searchBar.rx.text.orEmpty
//        .asDriver()
//        .throttle(.milliseconds(300))
//        .distinctUntilChanged()
//        .flatMapLatest { query in
//            Observable.just(query).asDriver(onErrorJustReturn: query)
//        }
//        _ = results.do(onNext: {
//            print($0)
//            print("")
//        })
    }

    private func setupCells() {
        // BindItems
          gameItems.bind(to: gameSearchTableView.rx.items(cellIdentifier: "GameSearchTableViewCell", cellType: GameSearchTableViewCell.self)) {
              (row, item, cell) in
            cell.gameImageView.loadImage(fromURL: item.cover?.url.replacingOccurrences(of: "//", with: "http://").replacingOccurrences(of: "t_thumb", with: "t_screenshot_big"))
              cell.gameTitleLabel.text = item.name
              cell.gameRatingLabel.text = String(describing: item.rating)
              cell.gameGenraLabel.text = item.genres?.compactMap{
                  $0.name
              }.reduce("", {
                  $0 + "\n" + $1
              })
          }.disposed(by: disposeBag)

                // willDisplayCell
        //        gameSearchTableView.rx.willDisplayCell
        //            .subscribe(onNext: ({ (cell,indexPath) in
        //                cell.alpha = 0
        //                let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -250, 0)
        //                cell.layer.transform = transform
        //                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
        //                    cell.alpha = 1
        //                    cell.layer.transform = CATransform3DIdentity
        //                }, completion: nil)
        //            })).disposed(by: disposeBag)
    }
    
}

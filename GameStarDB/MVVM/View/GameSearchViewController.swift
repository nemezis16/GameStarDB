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
    @IBOutlet var gameSearchTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!

    let gameSearchViewModel = GameSearchViewModel()
    let disposeBag = DisposeBag()

    var gameItems = PublishSubject<[GameListItem]>()
    var querySubject = PublishSubject<String>()

//MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()


        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)


        searchBar.rx.cancelButtonClicked
        .bind { self.searchBar.resignFirstResponder() }
        .disposed(by: disposeBag)

        gameSearchTableView.rx.didScroll
        .bind { self.searchBar.resignFirstResponder() }
        .disposed(by: disposeBag)


        self.setupBingings()
        self.gameSearchViewModel.requestData(data: "potter")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCells()
    }

//MARK: Private

    private func setupBingings() {
        
        // Loading
        gameSearchViewModel
        .loading
        .bind(to: rx.isAnimating)
        .disposed(by: disposeBag)
        
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
        
        searchBar
        .rx.text.orEmpty
        .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
        .distinctUntilChanged()
        .flatMapLatest { query -> Driver<String> in
            self.gameSearchViewModel.requestData(data: query)
            return Observable.just(query).asDriver(onErrorJustReturn: query)
        }
        .observeOn(MainScheduler.instance)
        .bind(to: querySubject)
        .disposed(by: disposeBag)

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
            item.rating.flatMap { cell.gameRatingLabel.text = String(format: "%.2f", $0) }
            cell.gameGenraLabel.text = item.genres?.compactMap {
                $0.name
            }.reduce("", { $0 + "\n" + $1 })
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

    @objc
    func adjustForKeyboard(notification: Notification) {
        switch notification.name {
        case UIResponder.keyboardWillShowNotification:
            searchBar.setShowsCancelButton(true, animated: true)

        case UIResponder.keyboardWillHideNotification:
            searchBar.setShowsCancelButton(false, animated: true)

        default: break
        }
    }
}

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

final class GameSearchViewController: UIViewController {

    @IBOutlet var gameSearchTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!

    let gameSearchViewModel = GameSearchViewModel()
    let disposeBag = DisposeBag()

    var gameItems = PublishSubject<[GameListItem]>()
    var querySubject = PublishSubject<String>()

//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupKeyboardBehavior()
        setupBingings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Setup here due warning (?)
        //"[TableView] Warning once only: UITableView was told to layout its visible cells and other contents without being in the view hierarchy (the table view or one of its superviews has not been added to a window). This may cause bugs by forcing views inside the table view to load and perform layout without accurate information (e.g. table view bounds, trait collection, layout margins, safe area insets, etc), and will also cause unnecessary performance overhead due to extra layout passes."
        setupCells()
        setupSelectingCell()
    }
}

//MARK: - Private
extension GameSearchViewController {
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
        .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
        .distinctUntilChanged()
        .flatMapLatest { query -> Driver<String> in
            self.gameSearchViewModel.requestData(data: query == "" ? "potter" : query)
            return Observable.just(query).asDriver(onErrorJustReturn: query)
        }
        .observeOn(MainScheduler.instance)
        .bind(to: querySubject)
        .disposed(by: disposeBag)
    }

    private func setupCells() {
        // TODO: - Move it to ViewModel, viewModel set to cell as in Wikipedia RX

        // BindItems
        gameItems.bind(to: gameSearchTableView.rx.items(cellIdentifier: "GameSearchTableViewCell", cellType: GameSearchTableViewCell.self)) {
            (row, item, cell) in
            cell.gameImageView.loadImage(fromURL: item.cover?.url.replacingOccurrences(of: "//", with: "http://").replacingOccurrences(of: "t_thumb", with: "t_screenshot_big"))
            cell.gameTitleLabel.text = item.name
            item.rating.flatMap { cell.gameRatingLabel.text = String(format: "Rating: %.2f", $0) }
            cell.gameGenraLabel.text = item.genres?.compactMap { $0.name }.joined(separator: ", ")
        }.disposed(by: disposeBag)
    }

    private func setupSelectingCell() {
        gameSearchTableView.rx.modelSelected(GameListItem.self)
        .asDriver()
        .drive(onNext: { print($0.name) })
        .disposed(by: disposeBag)
    }

    private func setupKeyboardBehavior() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
        .bind { _ in self.searchBar.setShowsCancelButton(true, animated: true) }
        .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIResponder.keyboardDidHideNotification)
        .bind { _ in self.searchBar.setShowsCancelButton(false, animated: true) }
        .disposed(by: disposeBag)

        searchBar.rx.cancelButtonClicked
        .bind { self.searchBar.resignFirstResponder() }
        .disposed(by: disposeBag)

        gameSearchTableView.rx.didScroll
        .bind { self.searchBar.resignFirstResponder() }
        .disposed(by: disposeBag)
    }
}


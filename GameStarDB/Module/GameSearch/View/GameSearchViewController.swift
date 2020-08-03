//
//  GameSearchViewController.swift
//  GameStarDB
//
//  Created by Roman Osadchuk on 06.01.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import Reusable
import RxDataSources

final class GameSearchViewController: UIViewController, StoryboardView, StoryboardBased {
    private typealias Action = GameSearchReactor.Action
    var disposeBag = DisposeBag()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    private lazy var footerActivityIndicator: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: 0, height: 30)
        return activityIndicatorView
    }()
    private let dataSource = RxTableViewSectionedReloadDataSource<GameSearchReactor.SectionType>(configureCell: {  _, tableView, indexPath, item in

        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: GameSearchTableViewCell.self)
        cell.gameImageView.loadImage(fromURL: item.cover?.url.replacingOccurrences(of: "//", with: "http://").replacingOccurrences(of: "t_thumb", with: "t_screenshot_big"))
        cell.gameTitleLabel.text = item.name
        item.rating.flatMap { cell.gameRatingLabel.text = String(format: "Rating: %.2f", $0) }
        cell.gameGenraLabel.text = item.genres?.compactMap { $0.name }.joined(separator: ", ")
        return cell
    })

    @IBOutlet var gameSearchTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        gameSearchTableView.tableFooterView = footerActivityIndicator

        definesPresentationContext = true

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        setupKeyboardBehavior()
    }

    func bind(reactor: GameSearchReactor) {
        let state = reactor.state.asDriver(onErrorJustReturn: reactor.initialState)
        //Read about Observer (Subscriber)
        state.map { $0.dataSource }.distinctUntilChanged().drive(gameSearchTableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        state.map { $0.isLoading }.drive(footerActivityIndicator.rx.isAnimating).disposed(by: disposeBag)
        searchController.searchBar.rx.text.orEmpty.map(Action.search).bind(to: reactor.action).disposed(by: disposeBag)
        gameSearchTableView.rx.reachedBottom(offset: 100.0).mapTo(Action.reachedBottom).bind(to: reactor.action).disposed(by: disposeBag)
        gameSearchTableView.rx.modelSelected(GameListItem.self).map(Action.selecteItem).bind(to: reactor.action).disposed(by: disposeBag)

        reactor.action.asObserver().onNext(.search("Harry Potter"))
    }

    private func setupKeyboardBehavior() {
        let searchBar = navigationItem.searchController?.searchBar
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .bind { _ in searchBar?.setShowsCancelButton(true, animated: true) }
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIResponder.keyboardDidHideNotification)
            .bind { _ in searchBar?.setShowsCancelButton(false, animated: true) }
            .disposed(by: disposeBag)

        searchBar?.rx.cancelButtonClicked
            .bind { searchBar?.resignFirstResponder() }
            .disposed(by: disposeBag)

        gameSearchTableView.rx.didScroll
            .bind { searchBar?.resignFirstResponder() }
            .disposed(by: disposeBag)
    }
}

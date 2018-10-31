//
//  NewsListScene.swift
//
//  Created by Oleksandr Harmash
//  Copyright © Oleksandr Harmash. All rights reserved.
//


enum NewsListScene {
    typealias View = NewsListViewProtocol
    typealias Presenter = NewsListPresenterProtocol
    typealias Router = NewsListRouterProtocol
    
    typealias Repository = NewsListRepositoryProtocol
    typealias EmptyStateProvider = NewsListEmptyStateProviderProtocol
    
    enum AvailableRoutes {
        case details
        case menu
    }
}

protocol NewsListViewProtocol: class, TableViewController, InfiniteLoadingCollection, Refreshable, ToastMessageView {
    var presenter: NewsListScene.Presenter! { get }
}

protocol NewsListPresenterProtocol: Presentable, ItemViewPresenterProtocol {
    var view: NewsListScene.View? { get }
    var router: NewsListScene.Router { get }
    var repository: NewsListScene.Repository { get }
    
    var canLoadMore: Bool { get }
    func loadMoreData()
    func refreshData()
    
    func present(_ view: NewsItemView, forRowAt indexPath: IndexPath)
    
    func onMenuPressed()
}

protocol NewsListRepositoryProtocol: TableDataSource, InfiniteLoadingRepository {
    var emptyStateProvider: NewsListScene.EmptyStateProvider { get }
    
    func loadMore(_ completion: @escaping LoadingCompletion)
    func refresh(_ completion: @escaping LoadingCompletion)
    
    func itemAt(_ indexPath: IndexPath) -> NewsModel?
}

protocol NewsListEmptyStateProviderProtocol: TableViewEmptyStateProviderProtocol, DelegateLessEmptyStateProviderProtocol {}

protocol NewsListRouterProtocol {
    func route(to route: NewsListScene.AvailableRoutes)
}

extension NewsListPresenterProtocol {
    func present(_ view: ItemViewProtocol, forRowAt indexPath: IndexPath) {
        if let menuvItemView = view as? NewsItemTableViewCell {
            present(menuvItemView, forRowAt: indexPath)
        }
    }
}

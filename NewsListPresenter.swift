//
//  NewsListPresenter.swift
//
//  Created by Oleksandr Harmash
//  Copyright © Oleksandr Harmash. All rights reserved.
//

import Foundation

class NewsListPresenter: NewsListScene.Presenter {
    weak var view: NewsListScene.View?
    var router: NewsListScene.Router
    var repository: NewsListScene.Repository
    
    var holder: Holder

    var canLoadMore: Bool { return repository.canLoadMore }
    
    init(_ view: NewsListScene.View,
         router: NewsListScene.Router,
         repository: NewsListScene.Repository,
         holder: Holder) {
        self.view = view
        self.router = router
        self.repository = repository
        self.holder = holder
        
        self.repository.emptyStateProvider.setDidTapViewHandler { [weak self] (_, _) in
            self?.refreshData()
        }
        
        self.repository.emptyStateProvider.setDidTapButtonHandler { [weak self] (_, _) in
            self?.refreshData()
        }
    }
    
    func start() {
        loadMoreData()
    }
    
    func loadMoreData() {
        repository.loadMore {[weak self] (result) in
            self?.view?.hideInfiniteLoading()
            self?.handle(response: result)
        }
    }
    
    func refreshData() {
        repository.refresh { [weak self] (result) in
            self?.view?.endRefreshing()
            self?.handle(response: result)
        }
    }

    private func handle(response: LoadedState) {
        //If repository isEmpty - EmptyStateProvider will show error info
        guard case .failed(let errors) = response,
            repository.isEmpty == false else { return }
        
        //If some data already exist - view should show error info
        let description = errors?.fullDescription ?? ErrorMessage.ooops.localized
        view?.show(message: description)
    }
    
    func present(_ view: NewsItemView, forRowAt indexPath: IndexPath) {
        if let item = repository.itemAt(indexPath) {
            view.show(item: item)
        }
    }
    
    func selectItem(at indexPath: IndexPath) {
        guard let item = repository.itemAt(indexPath) else { return }
        holder.hold(object: item)
        router.route(to: .details)
    }
    
    func onMenuPressed() {
        router.route(to: .menu)
    }
}

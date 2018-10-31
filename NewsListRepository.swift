//
//  NewsListRepository.swift
//
//  Created by Oleksandr Harmash
//  Copyright © Oleksandr Harmash. All rights reserved.
//


import UIKit

class NewsListRepository: SingleSectionTableDataSource<ShortNews>, NewsListScene.Repository {
    var canLoadMore: Bool {
        return pagination?.allowNext ?? false
    }
    var emptyStateProvider: NewsListScene.EmptyStateProvider
    
    private var api: NewsApiRouter
    

    private var pagination: PaginationModel?
    private var nextPage: Int32? {
        if let page = pagination?.currentPage {
            return page + 1
        }
        return nil
    }
    
    var isEmpty: Bool { return items.isEmpty }
    
    init(api: NewsApiRouter, emptyStateProvider: NewsListScene.EmptyStateProvider) {
        self.api = api
        self.emptyStateProvider = emptyStateProvider
        super.init()
    }
    
    override func set(tableView: UITableView?) {
        super.set(tableView: tableView)
        emptyStateProvider.set(table: tableView)
    }
    
    func loadMore(_ completion: @escaping LoadingCompletion) {
        load(refreshing: false, completion: completion)
    }
    
    func refresh(_ completion: @escaping LoadingCompletion) {
        load(refreshing: true, completion: completion)
    }

    private func load(refreshing: Bool, completion: @escaping LoadingCompletion) {
        let page = refreshing ? nil : nextPage
        
        emptyStateProvider.loadingStarted()
        api.load(page: page) {[weak self] (result) in
            
            defer {
                let state = result.loadedState
                self?.emptyStateProvider.loadingFinished(state: state)
                completion(state)
            }

            guard case .success(let data) = result,
                let respData = data else { return }
            
            if refreshing { self?.set(respData.news) }
                else { self?.append(respData.news) }
            self?.pagination = respData.pagination
        }
    }
    
    func itemAt(_ indexPath: IndexPath) -> NewsModel? {
        return super.itemAt(indexPath)
    }
}

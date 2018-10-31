//
//  NewsListEmptyStateProvider.swift
//
//  Created by Oleksandr Harmash
//  Copyright © Oleksandr Harmash. All rights reserved.
//

import UIKit

class NewsListEmptyStateProvider: TableViewEmptyStateProvider, NewsListScene.EmptyStateProvider {
    override init() {
        super.init()
        dataSource = self
    }
}

extension NewsListEmptyStateProvider: EmptyStateProviderDataSource {
    func description(for scrollView: UIScrollView, state: LoadingState) -> NSAttributedString? {
        guard case .loaded(.failed(let reason)) = state,
            let errorDescription = reason?.fullDescription else { return nil }
        
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17.0)]
        return NSAttributedString(string: errorDescription, attributes: attributes)
    }
    
    func image(for scrollView: UIScrollView, state: LoadingState) -> UIImage? {
        switch state {
            case .none, .loading: return nil
            case .loaded(.success): return #imageLiteral(resourceName: "EmptyStateNoNews")
            case .loaded(.failed(_)): return #imageLiteral(resourceName: "EmptyStateError")
        }
    }
    
    func buttonTitle(for scrollView: UIScrollView, for controlState: UIControlState, state: LoadingState) -> NSAttributedString? {
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 13.0)]
        return NSAttributedString(string: UIMessage.general(.tryAgain).localized, attributes: attributes)
    }
}


//
//  NewsListRouter.swift
//
//  Created by Oleksandr Harmash
//  Copyright © Oleksandr Harmash. All rights reserved.
//


class NewsListRouter: Router, NewsListRouterProtocol {
    func route(to route: NewsListScene.AvailableRoutes) {
        switch route {
            case .menu:
                controller?.sideMenuController?.revealMenu()
            case .details:
                performSegue(withIdentifier: Segue.news(.toDetails).segueId)
        }
    }
}

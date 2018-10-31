//
//  NewsListViewController.swift
//
//  Created by Oleksandr Harmash
//  Copyright © Oleksandr Harmash. All rights reserved.
//

import UIKit

import UIScrollView_InfiniteScroll

class NewsListViewController: BaseViewController, NewsListScene.View {
    var presenter: NewsListScene.Presenter!
    
    @IBOutlet var tableView: UITableView!

    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refresh(sender:)) , for: .valueChanged)
        control.tintColor = UIColor.lightGray
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isNavigationBarHidden = false
        
        tableView.delegate = self
        tableView.allowsSelection = true

        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.rowHeight = 152
        
        tableView.infiniteScrollTriggerOffset = 200
        tableView.addInfiniteScroll {[weak self] _ in
            self?.presenter.loadMoreData()
        }

        tableView.setShouldShowInfiniteScrollHandler { [weak self] _ in
            self?.presenter.canLoadMore ?? false
        }

        presenter.repository.set(tableView: tableView)
        presenter.repository.addConfiguration(NewsItemTableViewCell.self) { [weak self] (cell, indexPath) in
            guard let sSelf = self else { return }
            cell.selectionStyle = .none
            sSelf.presenter.present(cell, forRowAt: indexPath)
        }
        
        tableView.addSubview(refreshControl)
        
        presenter.start()
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        presenter.refreshData()
    }
    
    @IBAction func onMenuPressed(_ sender: UIBarButtonItem) {
        presenter.onMenuPressed()
    }
    
}

extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.selectItem(at: indexPath)
    }
}

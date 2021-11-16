//
//  ViewController.swift
//  CommentsApp
//
//  Created by Elvis on 11/11/21.
//

import UIKit

private enum Constants {
    static let rowHeight: CGFloat = 110.0
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: HomeViewModelProtocol = HomeViewModel(render: {})
    var coordinator: HomeRouterProtocol = HomeRouter()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        viewModel = HomeViewModel(render: render)
        title = viewModel.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl.beginRefreshing()
        startLoading()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopLoading()
        refreshControl.endRefreshing()
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.state {
        case .isLoading:
            let items = viewModel.data.count
            let itemsWithLoading = items + 1
            return (items > 0) ? itemsWithLoading : 0
        default:
            return viewModel.data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as? CommentTableViewCell
        
        // Fetch new page if needed
        let section = indexPath.section
        let lastRow = tableView.numberOfRows(inSection: section) - 1
        if row == lastRow {
            DispatchQueue.global(qos: .background).async {[weak self] in
                self?.viewModel.fetchNextPage()
            }
        }
        
        if let cell = cell {
            switch (viewModel.state, row) {
                
                // last cell in loading mode
                case (.isLoading, viewModel.data.count):
                    cell.setupLoading()
                
                // every other cell
                default:
                    let comment = viewModel.data[row]
                    cell.setup(comment: comment)
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if row < viewModel.data.count {
            let comment = viewModel.data[row]
            coordinator.presentAlert(for: comment, with: self)
            
            viewModel.lastSelected = comment
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let lastSelected = viewModel.lastSelected {
            let headerView = createHeader(comment: lastSelected)
            return headerView
        }

        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _ = viewModel.lastSelected {
            return 50
        }

        return 0
    }
}

extension HomeViewController {
    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
        tableView.rowHeight = Constants.rowHeight
        
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.addTarget(self, action: #selector(self.startLoading), for: .valueChanged)
        refreshControl.tintColor = AppTheme.homeCommentTextColor
        tableView.addSubview(refreshControl)
    }
    
    @objc
    private func startLoading() {
        viewModel.fetchInitialPage()
    }
    
    private func loadNextPage() {
        viewModel.fetchNextPage()
    }
    
    private func stopLoading() {
        viewModel.stopFetching()
    }
    
    private func showTable() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {  [weak self] in
            self?.tableView.alpha = 1
        }
    }
    
    private func hideTable() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {  [weak self] in
            self?.tableView.alpha = 0
        }
    }
    
    private func render() {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else {return}
            self.viewModel.data.isEmpty ? self.hideTable() : self.showTable()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func createHeader(comment: Comment) -> UIView {
        let headerPadding: CGFloat = 32
        let headerLabelStartingPoint: CGFloat = 16
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 52))
        let label = UILabel()
        label.frame = CGRect.init(x: headerLabelStartingPoint, y: headerLabelStartingPoint, width: headerView.frame.width-headerPadding, height: headerView.frame.height-headerPadding)
        label.text = "Last selected: \(comment.title)"
        label.font = AppTheme.homeCommentTitleFont
        
        label.textColor = AppTheme.homeBackgroundColor
        headerView.backgroundColor = AppTheme.homeCommentTextColor
        headerView.addSubview(label)
        
        return headerView
    }
}




//
//  CollectionListController.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-17.
//

import UIKit

/// View controller displaying collection of `CollectionCellView` cells
final class CollectionListController: UIViewController {
    
    // UI
    private lazy var collectionView: UICollectionView = {
        let layout = CollectionViewLayout()
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.register(CollectionCellView.self, forCellWithReuseIdentifier: CollectionCellView.self.description())
        view.dataSource = self
        view.delegate = self
        view.refreshControl = self.refreshControl
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(CollectionListController.onRefresh(_:)), for: UIControl.Event.valueChanged)
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        return view
    }()
    
    // DI
    let viewModel: CollectionViewModel
    
    init(viewModel: CollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.viewModel.title
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.activityIndicator)
        
        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityIndicator.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        self.viewModel.onViewRefresh()
    }
    
    @objc private func onRefresh(_ : Any?) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.viewModel.onViewRefresh()
        }
    }
}

// MARK: - Conform to `UICollectionViewDataSource`
extension CollectionListController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellView.self.description(), for: indexPath) as? CollectionCellView else { fatalError("Undefined cell type") }
        
        self.viewModel.fillCell(cell, atIndexPath: indexPath)
        return cell
    }
}

// MARK: - Conform to `UICollectionViewDelegate`
extension CollectionListController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.collectionView.indexPathsForVisibleItems.forEach { (indexPath: IndexPath) in
            if indexPath.item == self.viewModel.numberOfItems-1 {
                self.viewModel.onViewDidReachEndOfList()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.onViewSelectedItemAtIndexPath(indexPath)
    }
}

// MARK: - Conform to `CollectionViewModelDelegate`
extension CollectionListController: CollectionViewModelDelegate {
    
    func collectionViewModel(_ model: CollectionViewModel, didChangeState state: CollectionViewModelState) {
        DispatchQueue.main.async {
            switch state {
                
            case .idle:
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
                
            case .refreshing:
                self.collectionView.reloadData()
                
            case .fetching:
                self.activityIndicator.startAnimating()
                
            case .inserting(let numberOfItems):
                self.collectionView.performBatchUpdates {
                    let startIndex = self.viewModel.numberOfItems - numberOfItems
                    let newIndexPaths = (startIndex ..< self.viewModel.numberOfItems).map { IndexPath(row: $0, section: 0) }
                    self.collectionView.insertItems(at: newIndexPaths)
                }
                self.viewModel.onViewDidInsertItems()
                
            case .error:
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
                
                let alertController = UIAlertController(title: "Error", message: "Problem fetching data", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Reload", style: UIAlertAction.Style.cancel, handler: { [weak self] _ in
                    self?.viewModel.onViewRefresh()
                }))
                self.present(alertController, animated: true)
            }
        }
    }
}

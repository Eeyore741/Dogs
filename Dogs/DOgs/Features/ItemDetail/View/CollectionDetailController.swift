//
//  CollectionDetailController.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-19.
//

import UIKit

final class CollectionDetailController: UIViewController {
    
    // DI
    private let viewModel: CollectionDetailViewModel
    private let contentTopOffset: CGFloat = -415
    
    // UI
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.textColor = .black
        view.isEditable = false
        view.automaticallyAdjustsScrollIndicatorInsets = true
        view.showsVerticalScrollIndicator = false
        view.isSelectable = false
        view.contentInset = UIEdgeInsets(top: -contentTopOffset, left: 0, bottom: 0, right: 0)
        view.backgroundColor = .clear
        view.textAlignment = .natural
        view.delegate = self
        return view
    }()
    
    private lazy var imageView: RemoteImageView = {
        let view = RemoteImageView(withImageCache: self.viewModel.imageCache)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        return view
    }()
    
    private lazy var gradientView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    init(viewModel: CollectionDetailViewModel) {
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
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.view.backgroundColor = .white
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.imageView)
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.imageView.heightAnchor.constraint(equalToConstant: 450)
        ])
        
        self.gradientView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.gradientView)
        NSLayoutConstraint.activate([
            self.gradientView.heightAnchor.constraint(equalToConstant: 55.0),
            self.gradientView.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor),
            self.gradientView.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor),
            self.gradientView.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor)
        ])
        
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.textView)
        NSLayoutConstraint.activate([
            self.textView.topAnchor.constraint(equalTo: self.view.readableContentGuide.topAnchor),
            self.textView.leadingAnchor.constraint(equalTo: self.view.readableContentGuide.leadingAnchor),
            self.textView.bottomAnchor.constraint(equalTo: self.view.readableContentGuide.bottomAnchor),
            self.textView.trailingAnchor.constraint(equalTo: self.view.readableContentGuide.trailingAnchor)
        ])
        
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.activityIndicator)
        
        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.textView.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.textView.centerYAnchor)
        ])
        
        self.viewModel.onViewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.gradientView.bounds
        gradientLayer.colors = [
            UIColor.init(white: 1.0, alpha: 0.0).cgColor,
            UIColor.white.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        self.gradientView.layer.addSublayer(gradientLayer)
    }
}

// MARK: - Conform to `UITextViewDelegate`
extension CollectionDetailController: UITextViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y < 0 else { return }
        
        let topOffset = scrollView.contentOffset.y
        if topOffset > self.contentTopOffset {
            self.imageView.alpha = 1.0 - (abs(self.contentTopOffset) - abs(topOffset)) / 200
        } else {
            self.imageView.alpha = 1.0
        }
    }
}

// MARK: - Conform to `CollectionDetailViewModelDelegate`
extension CollectionDetailController: CollectionDetailViewModelDelegate {
    
    func collectionDetailViewModel(_ viewModel: CollectionDetailViewModel, didChangeState state: CollectionDetailViewModelState) {
        switch state {
            
        case .idle:
            self.activityIndicator.stopAnimating()
            
            self.title = self.viewModel.title
            self.textView.attributedText = self.viewModel.text
            self.imageView.setRemoteImageWithUrl(self.viewModel.imageUrl)
            self.scrollViewDidScroll(self.textView)
            
        case .refreshing:
            self.activityIndicator.startAnimating()
            
        case .error:
            self.activityIndicator.stopAnimating()
            
            let alertController = UIAlertController(title: "Error", message: "Problem fetching data", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Reload", style: UIAlertAction.Style.cancel, handler: { [weak self] _ in
                self?.viewModel.onViewDidLoad()
            }))
            self.present(alertController, animated: true)
        }
    }
}

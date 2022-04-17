//
//  MainViewController.swift
//  Dogs
//
//  Created by vitalii.kuznetsov on 2022-04-17.
//

import UIKit


/// App main flow entrance point
final class MainViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.85)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

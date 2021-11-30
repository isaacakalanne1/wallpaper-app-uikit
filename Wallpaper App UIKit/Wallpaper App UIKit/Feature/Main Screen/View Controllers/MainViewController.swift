//
//  ViewController.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 30/11/2021.
//

import UIKit

class MainViewController: UIViewController {
    
    private let margin: CGFloat = 10
    
    let downloadButton = Button(style: .primary, title: "Download")
    let menuButton = Button(style: .secondary, image: UIImage(systemName: "circle.hexagonpath")!)
    
    let filterNavigatorView = FilterNavigatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.primary
        
        view.addSubview(downloadButton)
        view.addSubview(menuButton)
        view.addSubview(filterNavigatorView)
        
        NSLayoutConstraint.activate([
            menuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            menuButton.heightAnchor.constraint(equalToConstant: 60),
            menuButton.widthAnchor.constraint(equalToConstant: 60),
            menuButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margin),
            
            downloadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            downloadButton.trailingAnchor.constraint(equalTo: menuButton.leadingAnchor, constant: -margin),
            downloadButton.heightAnchor.constraint(equalToConstant: 60),
            downloadButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margin),
            
            filterNavigatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterNavigatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterNavigatorView.heightAnchor.constraint(equalToConstant: 60),
            filterNavigatorView.bottomAnchor.constraint(equalTo: downloadButton.topAnchor, constant: -margin - 10),
            
        ])
        
        insert(FilterNavigatorViewController(), into: filterNavigatorView)
    }

}

extension UIViewController {
    
    func insert(_ viewController: UIViewController, into view: UIView) {
        viewController.view.frame = view.bounds
        self.addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
}


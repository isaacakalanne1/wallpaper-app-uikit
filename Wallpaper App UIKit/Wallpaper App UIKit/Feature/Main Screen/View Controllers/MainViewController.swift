//
//  ViewController.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 30/11/2021.
//

import UIKit

class MainViewController: UIViewController {
    
    private let margin: CGFloat = 10
    private let viewHeight:  CGFloat = 60
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = margin
        return stackView
    }()
    
    let mainButtonContainer = MainButtonContainer()
    
    let filterNavigatorView = FilterNavigatorView()
    let slider = Slider()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.primary
        
        insert(FilterNavigatorViewController(), into: filterNavigatorView)
        
        stackView.addArrangedSubview(slider)
        stackView.addArrangedSubview(filterNavigatorView)
        stackView.addArrangedSubview(mainButtonContainer)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2*margin),
            
            filterNavigatorView.heightAnchor.constraint(equalToConstant: viewHeight),
            mainButtonContainer.heightAnchor.constraint(equalToConstant: viewHeight)
        ])
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


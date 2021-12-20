//
//  VideoViewController.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 20/12/2021.
//

import UIKit

class VideoViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.textColor = Color.accent
        label.backgroundColor = Color.secondary
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.textColor = Color.accent
        label.backgroundColor = Color.secondary
        return label
    }()
    
    let buttonStatus = SecondaryButtonContainer.ButtonStatus.earn1Point
    
    lazy var buttonContainer = SecondaryButtonContainer(delegate: self, status: buttonStatus)
    
    let viewHeight: CGFloat = 45
    let margin: CGFloat = 10
    
    let user = User()
    
    var points: Int {
        return user.points
    }
    
    let delegate: ButtonDelegate?
    
    init(delegate: ButtonDelegate?) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.primary
        
        updateLabelText()
        
        subtitleLabel.text = "Watch a video to earn 1 point"
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(buttonContainer)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            titleLabel.heightAnchor.constraint(equalToConstant: viewHeight),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: margin),
            subtitleLabel.heightAnchor.constraint(equalToConstant: viewHeight),
            
            buttonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonContainer.heightAnchor.constraint(equalToConstant: viewHeight),
            buttonContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }
    
    func updateLabelText() {
        switch points {
        case 1:
            titleLabel.text = "You have 1 point"
        default:
            titleLabel.text = "You have \(points) points"
        }
    }
    
}

extension VideoViewController: ButtonDelegate {
    func primaryButtonPressed(status: SecondaryButtonContainer.ButtonStatus) {
        user.savePoints(1)
        updateLabelText()
        print("Watch video")
    }
    
    func secondaryButtonPressed(status: SecondaryButtonContainer.ButtonStatus) {
        if let vc = navigationController?.children.first(where: { $0 is MainViewController }) {
            navigationController?.popToViewController(vc, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
        delegate?.secondaryButtonPressed(status: buttonStatus)
    }
}

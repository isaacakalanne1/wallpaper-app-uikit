//
//  SecondaryButtonContainer.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 06/12/2021.
//

import UIKit

protocol AnnouncementDelegate: AnyObject {
    func displayAnnouncement(_ text: String)
}

protocol ButtonDelegate: AnyObject {
    func primaryButtonPressed()
    func secondaryButtonPressed()
}

class SecondaryButtonContainer: UIView {
    
    enum ButtonStatus {
        case applyFilter, getPoints, earn1Point, unlockFilter, hide
        
        var animationAlpha: CGFloat {
            switch self {
            case .applyFilter, .getPoints, .earn1Point, .unlockFilter:
                return 1.0
            case .hide:
                return 0.0
            }
        }
        
        var primaryTitle: String? {
            switch self {
            case .applyFilter:
                return "Apply"
            case .getPoints:
                return "Get Points Free"
            case .earn1Point:
                return "Watch video"
            case .unlockFilter:
                return "Unlock for \(User().points) points"
            case .hide:
                return nil
            }
        }
        
        var secondaryTitle: String? {
            switch self {
            case .applyFilter,
                    .getPoints,
                    .unlockFilter:
                return "Cancel"
            case .earn1Point:
                return "Back"
            case .hide:
                return nil
            }
        }
    }
    
    private let margin: CGFloat = 5
    private let viewWidth: CGFloat = 100
    private let viewWidthLarge: CGFloat = 160
    
    let announcementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = Color.accent
        label.backgroundColor = Color.secondary
        return label
    }()
    
    lazy var primaryButton = Button(style: .primary, title: buttonStatus.primaryTitle)
    lazy var applyFilterPrimaryButtonWidth = primaryButton.widthAnchor.constraint(equalToConstant: viewWidth)
    lazy var getPointsPrimaryButtonWidth = primaryButton.widthAnchor.constraint(equalToConstant: viewWidthLarge)
    lazy var secondaryButton = Button(style: .secondary, title: buttonStatus.secondaryTitle)
    
    let delegate: ButtonDelegate?
    
    let animationLength = Animation.length
    
    var buttonStatus: ButtonStatus
    
    init(delegate: ButtonDelegate?, status: ButtonStatus) {
        self.delegate = delegate
        self.buttonStatus = status
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Color.secondary
        
        primaryButton.addTarget(self, action: #selector(primaryButtonPressed), for: .touchUpInside)
        secondaryButton.addTarget(self, action: #selector(secondaryButtonPressed), for: .touchUpInside)
        
        primaryButton.alpha = 0.0
        secondaryButton.alpha = 0.0
        
        addSubview(primaryButton)
        addSubview(secondaryButton)
        
        announcementLabel.alpha = 0
        addSubview(announcementLabel)
        
        NSLayoutConstraint.activate([
            primaryButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: margin),
            primaryButton.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            primaryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin),
            
            secondaryButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -margin),
            secondaryButton.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            secondaryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin),
            secondaryButton.widthAnchor.constraint(equalToConstant: viewWidth),
            
            announcementLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            announcementLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            announcementLabel.topAnchor.constraint(equalTo: topAnchor),
            announcementLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        applyFilterPrimaryButtonWidth.isActive = true
        
        toggleButtons(status)
    }
    
    @objc func primaryButtonPressed() {
        delegate?.primaryButtonPressed()
    }
    
    @objc func secondaryButtonPressed() {
        delegate?.secondaryButtonPressed()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func displayAnnouncement(_ text: String) {
        
        announcementLabel.text = text
        
        UIView.animate(withDuration: Animation.length, animations: {
            self.announcementLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: Animation.length, delay: 1.0) {
                self.announcementLabel.alpha = 0.0
            }
        }
    }
    
    func toggleButtons(_ status: ButtonStatus) {
        self.buttonStatus = status
        
        UIView.transition(with: primaryButton,
                          duration: Animation.length,
                          options: .transitionCrossDissolve) {
            self.primaryButton.setTitle(status.primaryTitle, for: .normal)
        }
        
        UIView.transition(with: secondaryButton,
                          duration: Animation.length,
                          options: .transitionCrossDissolve) {
            self.secondaryButton.setTitle(status.secondaryTitle, for: .normal)
        }
        
        switch status {
        case .applyFilter:
            getPointsPrimaryButtonWidth.isActive = false
            applyFilterPrimaryButtonWidth.isActive = true
        case .getPoints, .earn1Point, .unlockFilter:
            applyFilterPrimaryButtonWidth.isActive = false
            getPointsPrimaryButtonWidth.isActive = true
        case .hide:
            break
        }
        
        UIView.animate(withDuration: Animation.length) {
            self.primaryButton.alpha = status.animationAlpha
            self.secondaryButton.alpha = status.animationAlpha
        }
    }
    
    func updatePrimaryButtonInteraction(canInteract: Bool) {
        primaryButton.isUserInteractionEnabled = canInteract
        self.primaryButton.alpha = canInteract ? 1.0 : 0.5
    }
    
}

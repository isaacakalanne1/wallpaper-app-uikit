//
//  SecondaryButtonContainer.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 06/12/2021.
//

import UIKit

protocol AnnouncementDelegate: AnyObject {
    func displayAnnouncement(_ text: String, secondAnnouncement: String?)
}

protocol ButtonDelegate: AnyObject {
    func primaryButtonPressed(status: SecondaryButtonContainer.ButtonStatus)
    func primaryButtonPressedWhileDisabled(status: SecondaryButtonContainer.ButtonStatus)
    func secondaryButtonPressed(status: SecondaryButtonContainer.ButtonStatus)
}

class SecondaryButtonContainer: UIView {
    
    enum ButtonStatus {
        case applyFilter, hide
        
        var animationAlpha: CGFloat {
            switch self {
            case .applyFilter:
                return 1.0
            case .hide:
                return 0.0
            }
        }
        
        var primaryTitle: String? {
            switch self {
            case .applyFilter:
                return "Apply"
            case .hide:
                return nil
            }
        }
        
        var secondaryTitle: String? {
            switch self {
            case .applyFilter:
                return "Cancel"
            case .hide:
                return nil
            }
        }
    }
    
    private let margin: CGFloat = 5
    private let viewWidth: CGFloat = 100
    private let viewWidthLarge: CGFloat = 160
    private let viewWidthLargest: CGFloat = 180
    
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
    lazy var unlockFilterPrimaryButtonWidth = primaryButton.widthAnchor.constraint(equalToConstant: viewWidthLargest)
    lazy var secondaryButton = Button(style: .secondary, title: buttonStatus.secondaryTitle)
    
    let delegate: ButtonDelegate?
    
    let animationLength = Animation.length
    
    var buttonStatus: ButtonStatus
    
    var isPrimaryButtonEnabled = true
    
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
        if isPrimaryButtonEnabled {
            delegate?.primaryButtonPressed(status: buttonStatus)
        } else {
            delegate?.primaryButtonPressedWhileDisabled(status: buttonStatus)
        }
    }
    
    @objc func secondaryButtonPressed() {
        delegate?.secondaryButtonPressed(status: buttonStatus)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func displayAnnouncement(_ text: String, _ completion: (() -> Void)? = nil) {
        
        announcementLabel.text = text
        
        UIView.animate(withDuration: Animation.length, animations: {
            self.announcementLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: Animation.length, delay: 1.0, animations: {
                self.announcementLabel.alpha = 0.0
            }) { _ in
                completion?()
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
            unlockFilterPrimaryButtonWidth.isActive = false
            applyFilterPrimaryButtonWidth.isActive = true
        case .hide:
            break
        }
        
        UIView.animate(withDuration: Animation.length) {
            self.primaryButton.alpha = status.animationAlpha
            self.secondaryButton.alpha = status.animationAlpha
        }
    }
    
    func updatePrimaryButtonInteraction(canInteract: Bool) {
        isPrimaryButtonEnabled = canInteract
        self.primaryButton.alpha = canInteract ? 1.0 : 0.5
    }
    
}

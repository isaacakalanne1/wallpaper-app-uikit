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

class SecondaryButtonContainer: UIView {
    
    enum ButtonStatus {
        case show, hide
        
        var animationAlpha: CGFloat {
            switch self {
            case .show:
                return 1.0
            case .hide:
                return 0.0
            }
        }
    }
    
    private let margin: CGFloat = 5
    private let viewWidth: CGFloat = 100
    
    let announcementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = Color.accent
        label.backgroundColor = Color.secondary
        return label
    }()
    
    let primaryButton = Button(style: .primary, title: "Apply")
    let secondaryButton = Button(style: .secondary, title: "Cancel")
    
    let delegate: FilterDelegate?
    
    let animationLength = Animation.length
    
    init(delegate: FilterDelegate?) {
        self.delegate = delegate
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
            primaryButton.widthAnchor.constraint(equalToConstant: viewWidth),
            
            secondaryButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -margin),
            secondaryButton.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            secondaryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin),
            secondaryButton.widthAnchor.constraint(equalToConstant: viewWidth),
            
            announcementLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            announcementLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            announcementLabel.topAnchor.constraint(equalTo: topAnchor),
            announcementLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    @objc func primaryButtonPressed() {
        delegate?.applyFilter()
    }
    
    @objc func secondaryButtonPressed() {
        delegate?.cancelFilter()
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
        UIView.animate(withDuration: Animation.length) {
            self.primaryButton.alpha = status.animationAlpha
            self.secondaryButton.alpha = status.animationAlpha
        }
    }
    
}

//
//  TertiaryContainer.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 19/12/2021.
//

import UIKit

class TertiaryContainer: UIView {
    
    let announcementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = Color.accent
        label.backgroundColor = Color.secondary
        return label
    }()
    
    
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Color.secondary
        
        addSubview(announcementLabel)
        
        NSLayoutConstraint.activate([
            announcementLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            announcementLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            announcementLabel.topAnchor.constraint(equalTo: topAnchor),
            announcementLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func displayAnnouncement(_ text: String) {
        let prevText = announcementLabel.text
        
        UIView.transition(with: announcementLabel, duration: Animation.length, options: .transitionCrossDissolve) {
            
            self.announcementLabel.text = text
            
        } completion: { _ in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.transition(with: self.announcementLabel, duration: Animation.length, options: .transitionCrossDissolve) {
                    self.announcementLabel.text = prevText
                }
            }
            
        }
    }
    
    func displayPermanentAnnouncement(_ announcementText: String?) {
        if let text = announcementText {
            announcementLabel.text = text
            isHidden = false
        } else {
            isHidden = true
            announcementLabel.text = ""
        }
    }
}

//
//  NearbyRLabel.swift
//  Hotels
//
//  Created by Narzullaev Nurbek on 29/01/23.
//

import UIKit

class BestAffordableLabel: UICollectionViewCell {
    
    static let identifier = "NearbyLabel"
    
    let label = UILabel()
    let seeAllBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        addSubview(seeAllBtn)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Best & Affordable"
        label.textColor = .deepBlack
        label.font = .systemFont(ofSize: LFSize, weight: .semibold)
        
        seeAllBtn.setTitle("See All", for: .normal)
        seeAllBtn.setTitleColor(.systemBlue, for: .normal)
        seeAllBtn.titleLabel?.font = .systemFont(ofSize: SAFSize, weight: .medium)
        seeAllBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: gridSize),
            
            seeAllBtn.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            seeAllBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gridSize)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error has occured")
    }
}

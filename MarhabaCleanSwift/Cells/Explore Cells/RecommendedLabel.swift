//
//  RecommendedLabel.swift
//  Hotels
//
//  Created by Narzullaev Nurbek on 29/01/23.
//

import UIKit

class RecommendedLabel: UICollectionViewCell {
    
    static let identifier = "RecommendedLabel"
    let seeAll = UIButton()
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addSubview(seeAll)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Recommended"
        label.textColor = .deepBlack
        label.font = .systemFont(ofSize: LFSize, weight: .semibold)
        
        seeAll.setTitle("See All", for: .normal)
        seeAll.setTitleColor(.systemBlue, for: .normal)
        seeAll.titleLabel?.font = .systemFont(ofSize: SAFSize, weight: .medium)
        seeAll.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: gridSize),
            
            seeAll.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            seeAll.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gridSize)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error has occured")
    }
}

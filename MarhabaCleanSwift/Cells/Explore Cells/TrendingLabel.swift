//
//  TrendingLabel.swift
//  Hotels
//
//  Created by Narzullaev Nurbek on 29/01/23.
//

import UIKit

class TrendingLabel: UICollectionViewCell {
    
    static let identifier = "TrendingLabel"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Trending destinations"
        label.textColor = .deepBlack
        label.font = .systemFont(ofSize: LFSize, weight: .semibold)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: gridSize)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error has occured")
    }
}

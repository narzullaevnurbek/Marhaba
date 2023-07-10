//
//  RoomsLabel.swift
//  HotelsUz
//
//  Created by Narzullaev Nurbek on 02/03/23.
//

import UIKit

class HotelAmensLabel: UICollectionViewCell {
    
    static let identifier = "HotelAmensLabel"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [label].forEach { item in
            addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        
        label.text = "Hotel amenities"
        label.font = .systemFont(ofSize: LFSize, weight: .semibold)
        label.textColor = .deepBlack
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: gridSize),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("error")
    }
}

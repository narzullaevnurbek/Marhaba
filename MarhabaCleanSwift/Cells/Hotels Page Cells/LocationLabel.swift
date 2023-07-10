//
//  LocationLabel.swift
//  HotelsUz
//
//  Created by Narzullaev Nurbek on 02/03/23.
//

import UIKit

class LocationLabel: UICollectionViewCell {
    
    static let identifier = "LocationLabel"
    
    let label = UILabel()
    let address = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [label, address].forEach { item in
            addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        
        label.text = "Location"
        label.font = .systemFont(ofSize: LFSize, weight: .semibold)
        label.textColor = .deepBlack
        
        address.textColor = .grey
        address.font = .systemFont(ofSize: 18, weight: .regular)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: gridSize),
            
            address.topAnchor.constraint(equalTo: label.bottomAnchor),
            address.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            address.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gridSize)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("error")
    }
}

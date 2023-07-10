//
//  Amenities.swift
//  HotelsUz
//
//  Created by Narzullaev Nurbek on 02/03/23.
//

import UIKit

class HotelAmens: UICollectionViewCell {
    
    static let identifier = "HotelAmens"
    
    let icon = UIImageView()
    let text = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [icon, text].forEach { item in
            addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        
        icon.image = UIImage(named: "icon1")
        icon.image = icon.image?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = .deepBlack
        
        text.text = "Free wi-fi"
        text.font = .systemFont(ofSize: 16, weight: .medium)
        text.textColor = .deepBlack
        
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: gridSize),
            icon.widthAnchor.constraint(equalToConstant: icon.image!.size.width * 1.5),
            icon.heightAnchor.constraint(equalToConstant: icon.image!.size.height * 1.5),
            text.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
            text.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            text.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gridSize)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("error")
    }
}

//
//  TrendingPlaces.swift
//  Hotels
//
//  Created by Narzullaev Nurbek on 29/01/23.
//

import UIKit

class TrendingPlaces: UICollectionViewCell {

    static let identifier = "TrendingPlaces"
    
    var image = UIImageView()
    var name = UILabel()
    var hotelsCount = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [image, name, hotelsCount].forEach { item in
            addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        
        views()
        layout()
        
    }
    
    func views() {
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        
        name.text = "Samarkand"
        name.font = .systemFont(ofSize: 20, weight: .medium)
        name.textColor = .white
        name.backgroundColor = .deepBlack.withAlphaComponent(0.6)
        name.layer.masksToBounds = true
        name.layer.cornerRadius = 5
        name.textAlignment = .center
        
        hotelsCount.text = "+240 hotels"
        hotelsCount.font = .systemFont(ofSize: 13, weight: .bold)
        hotelsCount.textColor = .white
        hotelsCount.backgroundColor = .deepBlack.withAlphaComponent(0.6)
        hotelsCount.layer.masksToBounds = true
        hotelsCount.layer.cornerRadius = 5
        hotelsCount.textAlignment = .center
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            name.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -10),
            name.centerXAnchor.constraint(equalTo: image.centerXAnchor),
            name.widthAnchor.constraint(equalToConstant: 125),
            name.heightAnchor.constraint(equalToConstant: 35),
            
            hotelsCount.topAnchor.constraint(equalTo: image.topAnchor, constant: 10),
            hotelsCount.leadingAnchor.constraint(equalTo: image.leadingAnchor, constant: 10),
            hotelsCount.widthAnchor.constraint(equalToConstant: 90),
            hotelsCount.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error has occured")
    }
}

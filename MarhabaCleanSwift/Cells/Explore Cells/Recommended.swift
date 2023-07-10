//
//  Recommended.swift
//  Hotels
//
//  Created by Narzullaev Nurbek on 29/01/23.
//

import UIKit

class Recommended: UICollectionViewCell {

    static let identifier = "Recommended"
    
    var image = UIImageView()
    var ratingView = UIView()
    var rate = UILabel()
    var rateIcon = UIImageView()
    var name = UILabel()
    var address = UILabel()
    var price = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [image, ratingView, rate, rateIcon, name, address, price].forEach { item in
            addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        
        views()
        layout()
        
    }
    
    func views() {
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 5
        
        ratingView.backgroundColor = .deepBlack.withAlphaComponent(0.6)
        ratingView.layer.cornerRadius = 5
        
        rate.text = "4.8"
        rate.font = .systemFont(ofSize: 18, weight: .semibold)
        rate.textColor = .white
        
        rateIcon.image = UIImage(named: "star")
        
        name.text = "Nodirabegim Hotel"
        name.font = .systemFont(ofSize: 20, weight: .semibold)
        
        address.text = "Eshoni-Pir 63 street, 200118 Bukhara"
        address.font = .systemFont(ofSize: captionSize, weight: .regular)
        address.textColor = .grey
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.widthAnchor.constraint(equalToConstant: RDIImageWidth),
            image.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            ratingView.widthAnchor.constraint(equalToConstant: 55),
            ratingView.heightAnchor.constraint(equalToConstant: 30),
            ratingView.bottomAnchor.constraint(equalTo: image.bottomAnchor),
            ratingView.trailingAnchor.constraint(equalTo: image.trailingAnchor),
            
            rate.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            rate.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: 4),
            
            rateIcon.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            rateIcon.trailingAnchor.constraint(equalTo: ratingView.trailingAnchor, constant: -6),
            
            name.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gridSize),
            
            address.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            address.topAnchor.constraint(equalTo: name.bottomAnchor),
            address.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            
            price.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            price.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("Error has occured")
    }
}

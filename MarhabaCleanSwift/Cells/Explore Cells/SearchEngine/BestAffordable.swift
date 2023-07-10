//
//  DowntownPlaced.swift
//  Hotels
//
//  Created by Narzullaev Nurbek on 29/01/23.
//

import UIKit

class BestAffordable: UICollectionViewCell {

    static let identifier = "BestAffordable"
    
    var image = UIImageView()
    var ratingView = UIView()
    var rate = UILabel()
    var rateIcon = UIImageView()
    var distance = UILabel()
    var name = UILabel()
    var address = UILabel()
    var price = UILabel()
    let attredText = NSMutableAttributedString()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [image, name, address, price, ratingView, rate, rateIcon].forEach { item in
            addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        
        views()
        layout()
        
    }
    
    func views() {
        
        layer.borderWidth = 2
        layer.borderColor = UIColor.smokyWhite.cgColor
        layer.cornerRadius = 5
        
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
        name.font = .systemFont(ofSize: 22, weight: .semibold)
        
        address.text = "Eshoni-Pir 63 street, 200118 Bukhara"
        address.textColor = .grey
        address.font = .systemFont(ofSize: captionSize, weight: .regular)
    }
    
    
    func layout() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            image.heightAnchor.constraint(equalToConstant: 180),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            
            ratingView.widthAnchor.constraint(equalToConstant: 60),
            ratingView.heightAnchor.constraint(equalToConstant: 30),
            ratingView.topAnchor.constraint(equalTo: image.topAnchor, constant: 10),
            ratingView.leadingAnchor.constraint(equalTo: image.leadingAnchor, constant: 10),
            
            rate.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            rate.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: 6),
            
            rateIcon.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            rateIcon.trailingAnchor.constraint(equalTo: ratingView.trailingAnchor, constant: -8),
            
            name.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10),
            name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            address.topAnchor.constraint(equalTo: name.bottomAnchor),
            address.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            address.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            
            price.topAnchor.constraint(equalTo: address.bottomAnchor, constant: 15),
            price.leadingAnchor.constraint(equalTo: address.leadingAnchor),
        ])
    }
    

    required init?(coder: NSCoder) {
        fatalError("Error has occured")
    }
}

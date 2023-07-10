//
//  HotelInfoContainer.swift
//  HotelsUz
//
//  Created by Narzullaev Nurbek on 02/03/23.
//

import UIKit

class HotelDesc: UICollectionViewCell, DescriptionEditionDelegate {
    
    static let identifier = "HotelDesc"
    
    var name = UILabel()
    var address = UILabel()
    var desc = UILabel()
    var readMoreBtn = UIButton()
    
    var ratingView = UIView()
    var rate = UILabel()
    var rateIcon = UIImageView()
    var starsArray = [UIImageView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [name, address, desc, readMoreBtn, ratingView, rate, rateIcon].forEach { item in
            addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        
        views()
        layout()
    }
    
    
    
    
    func views() {
        
        name.text = "Nodirabegim Hotel"
        name.textColor = .deepBlack
        name.font = .systemFont(ofSize: LFSize, weight: .semibold)
        
        ratingView.backgroundColor = .deepBlack
        ratingView.layer.cornerRadius = 5
        
        rate.text = "4.8"
        rate.font = .systemFont(ofSize: 18, weight: .semibold)
        rate.textColor = .white
        
        rateIcon.image = UIImage(named: "star")
        
        address.textColor = .grey
        address.font = .systemFont(ofSize: 16, weight: .regular)
        address.numberOfLines = 1
        
        desc.textColor = .deepBlack
        desc.font = .systemFont(ofSize: 18, weight: .regular)
        desc.lineBreakMode = .byWordWrapping
        desc.numberOfLines = 4
        
        readMoreBtn.setTitle("Show More", for: .normal)
        readMoreBtn.setTitleColor(.systemBlue, for: .normal)
        readMoreBtn.titleLabel?.font = .systemFont(ofSize: 18)
    }
    
    
    func layout() {
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: gridSize),
            name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gridSize),
            
            ratingView.widthAnchor.constraint(equalToConstant: 70),
            ratingView.heightAnchor.constraint(equalToConstant: 30),
            ratingView.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 25),
            ratingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gridSize),
            
            rate.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            rate.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: 10),
            
            rateIcon.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            rateIcon.trailingAnchor.constraint(equalTo: ratingView.trailingAnchor, constant: -10),
            
            address.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 35),
            address.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            address.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -90),
            
            desc.topAnchor.constraint(equalTo: address.bottomAnchor, constant: 10),
            desc.leadingAnchor.constraint(equalTo: leadingAnchor, constant: gridSize),
            desc.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gridSize),
            
            readMoreBtn.topAnchor.constraint(equalTo: desc.bottomAnchor, constant: 5),
            readMoreBtn.leadingAnchor.constraint(equalTo: desc.leadingAnchor),
        ])
    }
    
    
    func changeDesc(isFull: Bool) {
        if isFull {
            desc.numberOfLines = 4
            readMoreBtn.setTitle("Show More", for: .normal)
        } else {
            desc.numberOfLines = .max
            readMoreBtn.setTitle("Show Less", for: .normal)
        }
    }
    
    
    func starsSetup(rating: Double) {
        if Int(rating) != 0 {
            for _ in 1...Int(rating) {
                starsArray.append(UIImageView.init(image: UIImage(named: "goldStar")))
            }
            
            if rating - Double(Int(rating)) > 0.0 && rating - Double(Int(rating)) < 1.0 {
                starsArray.append(UIImageView.init(image: UIImage(named: "halfStar")))
            }
            
            for star in 0..<starsArray.count {
                addSubview(starsArray[star])
                starsArray[star].translatesAutoresizingMaskIntoConstraints = false
                starsArray[star].topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5).isActive = true
                starsArray[star].widthAnchor.constraint(equalToConstant: starsArray[star].image!.size.width * 1.3).isActive = true
                starsArray[star].heightAnchor.constraint(equalToConstant: starsArray[star].image!.size.height * 1.3).isActive = true
                if starsArray.firstIndex(of: starsArray[star]) == 0 {
                    starsArray[star].leadingAnchor.constraint(equalTo: leadingAnchor, constant: gridSize).isActive = true
                } else {
                    starsArray[star].leadingAnchor.constraint(equalTo: starsArray[star-1].trailingAnchor, constant: 5).isActive = true
                }
            }
        } else {
            starsArray.append(UIImageView.init(image: UIImage(named: "goldStar")))
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("Error has occured")
    }
}

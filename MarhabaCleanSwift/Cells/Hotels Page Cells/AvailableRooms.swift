//
//  HotelLocation.swift
//  HotelsUz
//
//  Created by Narzullaev Nurbek on 02/03/23.
//

import UIKit

class AvailableRooms: UICollectionViewCell {
    
    static let identifier = "AvailableRooms"
    
    var image = UIImageView()
    var name = UILabel()
    var roomSizeIcon = UIImageView()
    var roomSize = UILabel()
    var price = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [image, name].forEach { item in
            addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        
        views()
        layout()
    }
    
    func views() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.smokyWhite.cgColor
        self.layer.cornerRadius = 5
        
        image.image = UIImage(named: "image")
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 5
        
        name.text = "Nodirabegim Hotel"
        name.font = .systemFont(ofSize: 20, weight: .semibold)
        
//        roomSizeIcon.image = UIImage(named: "roomSize")
//        roomSize.text = "10m²"
//        roomSize.textColor = .grey
//        roomSize.font = .systemFont(ofSize: 16, weight: .regular)
//
//        let attredText = NSMutableAttributedString()
//        attredText.bold("$185", fontSize: 22, textColor: .deepBlack)
//        attredText.normal("/per night", fontSize: 15, textColor: .grey)
//        price.attributedText = attredText
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            image.heightAnchor.constraint(equalToConstant: 180),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            
            name.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10),
            name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
//            roomSizeIcon.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
//            roomSizeIcon.leadingAnchor.constraint(equalTo: name.leadingAnchor),
//            roomSizeIcon.widthAnchor.constraint(equalToConstant: roomSizeIcon.image!.size.width * 1.1),
//            roomSizeIcon.heightAnchor.constraint(equalToConstant: roomSizeIcon.image!.size.height * 1.1),
//
//            roomSize.leadingAnchor.constraint(equalTo: roomSizeIcon.trailingAnchor, constant: 10),
//            roomSize.centerYAnchor.constraint(equalTo: roomSizeIcon.centerYAnchor),
//
//            price.topAnchor.constraint(equalTo: roomSizeIcon.bottomAnchor, constant: 15),
//            price.leadingAnchor.constraint(equalTo: roomSizeIcon.leadingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//
//  HotelImage.swift
//  HotelsUz
//
//  Created by Narzullaev Nurbek on 02/03/23.
//

import UIKit

class ImagesCell: UICollectionViewCell {
    
    static let identifier = "ImagesCell"
    
    var image = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(image)
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("Error has occured")
    }
}

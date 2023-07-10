//
//  HotelImage.swift
//  HotelsUz
//
//  Created by Narzullaev Nurbek on 02/03/23.
//

import UIKit

class HotelImageCell: UICollectionViewCell {
    
    static let identifier = "HotelImage"
    
    let image = UIImageView()
    let bottomRound = UIView()
    let showAllPhotos = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(image)
        addSubview(bottomRound)
        addSubview(showAllPhotos)
        
        image.image = UIImage(named: "samarkand")
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        
        bottomRound.backgroundColor = .white
        bottomRound.layer.cornerRadius = 10
        bottomRound.translatesAutoresizingMaskIntoConstraints = false
        
        showAllPhotos.setTitle("All photos", for: .normal)
        showAllPhotos.setTitleColor(.deepBlack, for: .normal)
        showAllPhotos.titleLabel?.font = .systemFont(ofSize: PRSize, weight: .medium)
        showAllPhotos.layer.cornerRadius = 10
        showAllPhotos.translatesAutoresizingMaskIntoConstraints = false
        showAllPhotos.backgroundColor = .smokyWhite
        //showAllPhotos.isHidden = true
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            bottomRound.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomRound.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomRound.heightAnchor.constraint(equalToConstant: 20),
            bottomRound.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10),
            
            showAllPhotos.widthAnchor.constraint(equalToConstant: 100),
            showAllPhotos.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            showAllPhotos.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.showAllPhotos.isHidden = false
//        }
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("Error has occured")
    }
}

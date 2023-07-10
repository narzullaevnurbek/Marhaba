//
//  LocationMap.swift
//  HotelsUz
//
//  Created by Narzullaev Nurbek on 02/03/23.
//

import UIKit

class LocationMap: UICollectionViewCell {
    
    static let identifier = "LocationMap"
    
    let openInMapsBtn = CustomButton(style: .black, title: "Open Location in Maps", shadow: .shadow)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureMap()
        
    }
    
    func configureMap() {
        addSubview(openInMapsBtn)
        openInMapsBtn.translatesAutoresizingMaskIntoConstraints = false
        
        layout()
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            openInMapsBtn.heightAnchor.constraint(equalToConstant: buttonHeight),
            openInMapsBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: gridSize),
            openInMapsBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            openInMapsBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gridSize),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        print("Deinited")
    }
}

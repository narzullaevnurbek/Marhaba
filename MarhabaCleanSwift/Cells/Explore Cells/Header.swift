//
//  TopBar.swift
//  Hotels
//
//  Created by Narzullaev Nurbek on 29/01/23.
//

import UIKit

class Header: UICollectionViewCell {

    static let identifier = "Header"
    
    let uzbLogo = UIImageView()
    let logOutBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        [uzbLogo, logOutBtn].forEach { item in
//            addSubview(item)
//            item.translatesAutoresizingMaskIntoConstraints = false
//        }
        
        //views()
        //layout()
    }
    
    func views() {
        uzbLogo.image = UIImage(named: "uzbekistan")
        
        logOutBtn.setImage(UIImage(named: "logout"), for: .normal)
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            uzbLogo.centerYAnchor.constraint(equalTo: centerYAnchor),
            uzbLogo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: gridSize),
            uzbLogo.widthAnchor.constraint(equalToConstant: (uzbLogo.image?.size.width)! * 1.4),
            uzbLogo.heightAnchor.constraint(equalToConstant: (uzbLogo.image?.size.height)! * 1.4),
            
            
            logOutBtn.centerYAnchor.constraint(equalTo: uzbLogo.centerYAnchor),
            logOutBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gridSize),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error has occured")
    }
}

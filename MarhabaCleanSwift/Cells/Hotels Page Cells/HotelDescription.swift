//
//  HotelDescription.swift
//  HotelsUz
//
//  Created by Narzullaev Nurbek on 30/04/23.
//

import UIKit

class HotelDescription: UIViewController {
    
    let desc: String
    
    init(desc: String) {
        self.desc = desc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let descLabel = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(descLabel)
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.text = desc
        descLabel.font = .systemFont(ofSize: 20)
        descLabel.numberOfLines = .max
        descLabel.lineBreakMode = .byWordWrapping
        
        NSLayoutConstraint.activate([
            descLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gridSize),
            descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -gridSize),
        ])
        
    }
    

    

}

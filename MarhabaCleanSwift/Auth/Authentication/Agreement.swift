//
//  Agreement.swift
//  HotelsUz
//
//  Created by Narzullaev Nurbek on 30/05/23.
//

import UIKit

class Agreement: UIViewController {
    
    let disclaimer = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(disclaimer)
        disclaimer.text = "Our company and the hotels listed in the app do not take the responsibility to sell their services with the prices indicated in the application, because all the prices are calculated by the beta engine of platform. All the prices are considered as the nearest compatible ones to the original price."
        disclaimer.font = .systemFont(ofSize: 20, weight: .medium)
        disclaimer.numberOfLines = .max
        disclaimer.translatesAutoresizingMaskIntoConstraints = false
        disclaimer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        disclaimer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        disclaimer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
    }
    

    

}

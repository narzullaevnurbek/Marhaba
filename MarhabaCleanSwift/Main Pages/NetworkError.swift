//
//  NetworkError.swift
//  HotelsUz
//
//  Created by Narzullaev Nurbek on 18/05/23.
//

import UIKit
import Network

class NetworkError: UIViewController {
    
    let label = UILabel()
    let image = UIImageView()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        checkInternetConnection()

        view.addSubview(label)
        label.text = "You're offline"
        label.textColor = .deepBlack
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(image)
        image.image = UIImage(named: "noInternet")
        image.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60)
        ])
    }
    
    
    func checkInternetConnection() {
        let queue = DispatchQueue(label: "Network")
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            
                
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: false)
                }
            }
            
        }
        
        monitor.start(queue: queue)
    }
    
}

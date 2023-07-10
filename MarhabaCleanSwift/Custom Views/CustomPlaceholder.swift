//
//  HButton.swift
//  HotelsUz
//
//  Created by Narzullaev Nurbek on 12/03/23.
//

import UIKit

class CustomPlaceholder: UILabel {
    
    let title: String
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        
        self.text = self.title
        self.textAlignment = .center
        self.backgroundColor = .white
        self.textColor = .grey
        self.font = .systemFont(ofSize: PRSize, weight: .medium)
    }
    
    required init?(coder: NSCoder) {
        fatalError("error")
    }
}

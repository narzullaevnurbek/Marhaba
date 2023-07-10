//
//  HButton.swift
//  HotelsUz
//
//  Created by Narzullaev Nurbek on 12/03/23.
//

import UIKit

enum CustomButtonStyle {
    case black
    case white
    case clear
    
    var backgroundColor: UIColor {
        switch self {
        case .black: return .deepBlack
        case .white: return .smokyWhite
        case .clear: return .clear
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .black: return .white
        case .white: return .deepBlack
        case .clear: return .deepBlack
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .black: return 0
        case .white: return 0
        case .clear: return 2
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .black: return .deepBlack
        case .white: return .smokyWhite
        case .clear: return .smokyWhite
        }
    }
}

enum ShadowStyle {
    case shadow
    case none
}

class CustomButton: UIButton {
    
    let style: CustomButtonStyle
    let title: String
    
    init(style: CustomButtonStyle, title: String, shadow: ShadowStyle) {
        self.title = title
        self.style = style
        super.init(frame: .zero)
        
        self.backgroundColor = style.backgroundColor
        self.setTitleColor(style.titleColor, for: .normal)
        self.layer.borderWidth = style.borderWidth
        self.layer.borderColor = style.borderColor.cgColor
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: BTSize, weight: .medium)
        self.layer.cornerRadius = buttonCornerRadius
        
        if shadow == ShadowStyle.shadow && self.isEnabled {
            self.layer.shadowColor = UIColor.darkGray.cgColor
            self.layer.shadowOpacity = 0.4
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowRadius = 5
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("error")
    }
}

extension CustomButton {
    func disabled() {
        self.isUserInteractionEnabled = false
        self.alpha = 0.2
    }
    
    func enabled() {
        self.isUserInteractionEnabled = true
        self.alpha = 1
    }
}

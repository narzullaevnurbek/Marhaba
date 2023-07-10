//
//  HTextField.swift
//  HotelsUz
//
//  Created by Narzullaev Nurbek on 12/03/23.
//

import UIKit

enum CustomTextFieldStyle {
    case info
    case picker
    
    var backgroundColor: UIColor {
        switch self {
        case .info: return .clear
        case .picker: return .smokyGrey
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .info: return 2
        case .picker: return 0
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .info: return .smokyWhite
        case .picker: return .smokyGrey
        }
    }
    
    var leftMargin: CGFloat {
        switch self {
        case .info: return TFLeftMargin
        case .picker: return TFLeftMargin + 25
        }
    }
    
    var rightMargin: CGFloat {
        switch self {
        case .info: return 60
        case .picker: return 60
        }
    }
}

class CustomTextField: UITextField {
    
    let style: CustomTextFieldStyle
    let placeholdeer: String?
    let iconName: String?
    let iconView = UIImageView()
    
    init(style: CustomTextFieldStyle, placeholdeer: String?, iconName: String?) {
        self.style = style
        self.placeholdeer = placeholdeer
        self.iconName = iconName
        super.init(frame: .zero)
        
        self.backgroundColor = style.backgroundColor
        self.font = .systemFont(ofSize: PRSize, weight: .medium)
        self.layer.cornerRadius = 10
        self.layer.borderWidth = style.borderWidth
        self.layer.borderColor = style.borderColor.cgColor
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        guard let placeholdeer = placeholdeer else { return }
        guard let iconName = iconName else { return }
        self.attributedPlaceholder = NSAttributedString( string: placeholdeer, attributes: [NSAttributedString.Key .foregroundColor: UIColor.deepBlack,])
        self.iconView.image = UIImage(named: iconName)
        self.iconView.translatesAutoresizingMaskIntoConstraints = false
        
        layout()
        
    }
    
    func layout() {
        
        if screenHeight >= 844 {
            addSubview(iconView)
            
            var iconLeftMargin: CGFloat = 13
            
            if self.iconName == "checkOut" {
                iconLeftMargin = 23
            }
            
            NSLayoutConstraint.activate([
                iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: iconLeftMargin),
                iconView.widthAnchor.constraint(equalToConstant: 24),
                iconView.heightAnchor.constraint(equalToConstant: 24),
            ])
        } else {
            self.textAlignment = .center
            self.font = .systemFont(ofSize: PRSize + 1, weight: .medium)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = bounds
        if screenHeight >= 844 && self.iconName != "checkOut" {
            rect.origin.x += style.leftMargin
            rect.size.width -= style.rightMargin
        } else if screenHeight >= 844 && self.iconName == "checkOut" {
            rect.origin.x += style.leftMargin + 10
            rect.size.width -= style.rightMargin
        }
        
        if screenHeight < 844 && style == .info {
            rect.origin.x += style.leftMargin
            rect.size.width -= style.rightMargin
        }
        
        return rect
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = bounds
        if screenHeight >= 844 && self.iconName != "checkOut" {
            rect.origin.x += style.leftMargin
            rect.size.width -= style.rightMargin
        } else if screenHeight >= 844 && self.iconName == "checkOut" {
            rect.origin.x += style.leftMargin + 10
            rect.size.width -= style.rightMargin
        }
        
        if screenHeight < 844 && style == .info {
            rect.origin.x += style.leftMargin
            rect.size.width -= style.rightMargin
        }
        
        return rect
    }
}

extension CustomTextField {
    func disabled() {
        self.isUserInteractionEnabled = false
        self.alpha = 0.6
    }
    
    func enabled() {
        self.isUserInteractionEnabled = true
        self.alpha = 1
    }
}

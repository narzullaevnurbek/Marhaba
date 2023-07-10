//
//  StringExtension.swift
//  HotelsUz
//
//  Created by Narzullaev Nurbek on 12/03/23.
//

import UIKit

extension NSMutableAttributedString {
    
    func bold(_ value: String, fontSize: CGFloat = 19, textColor: UIColor = .deepBlack, space: String = "", decoration: NSUnderlineStyle? = .none) {
        
        let decoration = decoration?.rawValue != nil ? decoration?.rawValue : 0
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: fontSize, weight: .bold),
            .foregroundColor: textColor,
            .underlineStyle: decoration,
        ]
        
        self.append(NSAttributedString(string: space + value, attributes:attributes))
    }
    
    func normal(_ value: String, fontSize: CGFloat = 19, textColor: UIColor = .deepBlack, space: String = "") {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: fontSize, weight: .regular),
            .foregroundColor: textColor,
        ]
        
        self.append(NSAttributedString(string: space + value, attributes:attributes))
    }
}

extension String {
    
    func isValidEmail() -> Bool {
        var result = false
        
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]{5,64}+\\@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
        let regexResult = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        
        if regexResult {
            let atSed = self.components(separatedBy: "@")
            let dotSed = atSed[1].components(separatedBy: ".")
            if dotSed[0].count >= 2 {
                result = true
            }
        }
        
        return result
    }
    
    func isValidName() -> Bool {
        if self.count >= 3 {
            return true
        } else {
            return false
        }
    }
    
    
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        let textSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let size = self.boundingRect(with: textSize,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font : font],
                                     context: nil)
        return ceil(size.height)
    }
}

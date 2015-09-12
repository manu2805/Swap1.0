//
//  Underline.swift
//  Layer-Parse-iOS-Swift-Example
//
//  Created by Manudeep N.s on 8/17/15.
//  Copyright (c) 2015 layer. All rights reserved.
//

import Foundation

class UnderlinedLabel: UILabel {
    
    override var text: String! {
        
        didSet {
            let textRange = NSMakeRange(0, count(text))
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSUnderlineStyleAttributeName , value:NSUnderlineStyle.StyleSingle.rawValue, range: textRange)
            // Add other attributes if needed
            
            self.attributedText = attributedText
        }
    }
}
//
//  AttributedStrings+Extension.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 03.04.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
    private var fullStringRange: NSRange {
        NSRange(string.startIndex ..< string.endIndex, in: string)
    }
    
    @discardableResult
    func color(_ color: UIColor, range: NSRange? = nil) -> NSMutableAttributedString {
        addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range ?? fullStringRange)
        return self
    }
    
    @discardableResult
    func font(_ font: UIFont, range: NSRange? = nil) -> NSMutableAttributedString {
        addAttribute(NSAttributedString.Key.font, value: font, range: range ?? fullStringRange)
        return self
    }
    
    @discardableResult
    func underline(_ range: NSRange? = nil) -> NSMutableAttributedString {
        addAttributes([
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.textSecondary
        ], range: range ?? fullStringRange)
        return self
    }
    
    @discardableResult
    func linkAction(
        color: UIColor? = nil,
        range: NSRange? = nil,
        isUnderlined: Bool = false,
        font: UIFont? = nil,
        action: @escaping NSAttributedString.LinkAction
    ) -> NSMutableAttributedString {
        if let color = color {
            self.color(color, range: range)
        }

        if let font = font {
            self.font(font)
        }

        addAttribute(NSAttributedString.Key.linkAction, value: action, range: range ?? fullStringRange)

        if isUnderlined {
            addAttribute(
                NSAttributedString.Key.underlineStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: range ?? fullStringRange
            )
            addAttribute(
                .underlineColor,
                value: UIColor.textSecondary,
                range: range ?? fullStringRange
            )
        }
        return self
    }
    
    @discardableResult
    func linkAction(
        color: UIColor? = nil,
        text: String,
        isUnderlined: Bool = false,
        font: UIFont? = nil,
        action: @escaping NSAttributedString.LinkAction
    ) -> NSMutableAttributedString {
        guard let range = string.range(of: text) else {
            return self
        }

        return linkAction(
            color: color,
            range: NSRange(range, in: string),
            isUnderlined: isUnderlined,
            font: font,
            action: action
        )
    }
    
}

extension NSAttributedString.Key {
    static let linkAction = NSAttributedString.Key("attributed_key_link_action")
}

extension NSAttributedString {
    typealias LinkAction = () -> Void
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSMutableAttributedString {
        let lhs = NSMutableAttributedString(attributedString: lhs)
        lhs.append(rhs)
        return lhs
    }
}

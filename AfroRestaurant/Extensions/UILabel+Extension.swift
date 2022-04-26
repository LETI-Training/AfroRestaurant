//
//  UILabel+Extension.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 03.04.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import UIKit
import ObjectiveC

extension UILabel {
    public func addLinkActionsObserving() {
        observeTap { [weak self] tapRecognizer in
            let location = tapRecognizer.location(in: self)
            if let action = self?.linkAction(at: location) {
                action()
            }
        }
    }
    
    func linkAction(at point: CGPoint) -> NSAttributedString.LinkAction? {
        guard let attributedText = attributedText,
            let index = indexOfAttributedTextCharacterAtPoint(point: point) else {
            return nil
        }
        let attributes = attributedText.attributes(at: index, effectiveRange: nil)
        return attributes[NSAttributedString.Key.linkAction] as? NSAttributedString.LinkAction
    }

    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int? {
        guard let attributedText = attributedText else {
            return nil
        }
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.lineBreakMode = lineBreakMode
        layoutManager.addTextContainer(textContainer)

        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
}

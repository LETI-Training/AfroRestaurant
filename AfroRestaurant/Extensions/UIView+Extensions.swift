//
//  UIView+Extensions.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 03.04.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import UIKit

extension UIView {
    
    private final class TapListener: NSObject {
        var handler: () -> Void

        init(handler: @escaping () -> Void) {
            self.handler = handler
        }

        @objc func onTap(_: UITapGestureRecognizer) {
            handler()
        }
    }
    
    fileprivate static let tapHandlers = AssociatedObject(policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC) { NSMutableSet() }
    
    func observeTap(_ handler: @escaping (_ tapRecognizer: UITapGestureRecognizer) -> Void) {
        let listener = TapListener(handler: {})
        let tapRecognizer = UITapGestureRecognizer(target: listener, action: #selector(TapListener.onTap(_:)))
        listener.handler = { [weak tapRecognizer] in
            if let tapRecognizer = tapRecognizer {
                handler(tapRecognizer)
            }
        }
        isUserInteractionEnabled = true
        addGestureRecognizer(tapRecognizer)
        UIView.tapHandlers.get(for: self).add(listener)
    }
}

//
//  WeakRefeferenceWrapper.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 04.04.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import Foundation

struct WeakRefeferenceWrapper<T>  {
    private weak var _object: AnyObject?
    
    var object: T? {
        get {
            return _object as? T
        }
        set {
            _object = newValue as AnyObject
        }
    }
    
    init(object: T) {
        self.object = object
        _object = object as AnyObject
    }
}

extension WeakRefeferenceWrapper: Equatable {
    static func == (lhs: WeakRefeferenceWrapper, rhs: WeakRefeferenceWrapper) -> Bool {
        lhs._object === rhs._object
    }
}

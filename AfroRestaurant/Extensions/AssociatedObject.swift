//
//  AssociatedObject.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 03.04.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import ObjectiveC

public final class AssociatedObject<T> {
    private var key = 0

    private let policy: objc_AssociationPolicy

    private let factory: () -> T

    init(policy: objc_AssociationPolicy, factory: @escaping () -> T) {
        self.policy = policy
        self.factory = factory
    }

    func get(for obj: Any) -> T {
        if let value = objc_getAssociatedObject(obj, &key) as? T {
            return value
        }
        let value = factory()
        objc_setAssociatedObject(obj, &key, value, policy)
        return value
    }
}

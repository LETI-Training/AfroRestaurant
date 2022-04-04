//
//  UIImage+Extensions.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 03.04.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import UIKit

extension UIImage {
    
    enum tabBarItems {
        static var home: UIImage { UIImage(named: "tab_home")! }
        static var inventory: UIImage { UIImage(named: "tab_inventory")! }
        static var profits: UIImage { UIImage(named: "tab_profits")! }
        static var homeHighlighted: UIImage { UIImage(named: "tab_home_highlighted")! }
        static var inventoryHighlighted: UIImage { UIImage(named: "tab_inventory_highlighted")! }
        static var profitsHighlighted: UIImage { UIImage(named: "tab_profits_highlighted")! }
    }
    
    static var afroHeader: UIImage { UIImage(named: "afro_header")! }
    static var like: UIImage { UIImage(named: "favorite")! }
    static var floatingDivider: UIImage { UIImage(named: "floatingDivider")! }
    static var logoSmall: UIImage { UIImage(named: "logo_small")! }
    static var logo: UIImage { UIImage(named: "logo")! }
    static var star: UIImage { UIImage(named: "Star")! }
    static var userIcon: UIImage { UIImage(named: "userIcon")! }
}

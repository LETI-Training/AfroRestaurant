//
//  AdminHome+NavigationViews.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 04.04.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import UIKit
import SnapKit

extension AdminHomeViewController {
    
    func makeRightBar(text: String) -> UIView {
        
        let starImageView = UIImageView(image: .star)
        starImageView.contentMode = .scaleAspectFit
        starImageView.snp.makeConstraints { make in
            make.width.equalTo(15.0)
        }
        let label = UILabel()
        label.text = text
        label.textColor = .textPrimary
        label.font = .font(.regular, size: 15.0)
        label.textAlignment = .left
        label.sizeToFit()
        
        let button = UIButton()
        button.addTarget(self, action: #selector(profileImageTapped), for: .touchUpInside)
        button.setImage(.userIcon, for: .normal)
        button.snp.makeConstraints { make in
            make.width.height.equalTo(36.0)
        }
        button.layer.cornerRadius = 18.0
        
        let stackView = UIStackView(arrangedSubviews: [
            starImageView,
            label,
            button
        ])
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0.5
        stackView.axis = .horizontal
        starImageView.snp.makeConstraints { make in
            make.height.equalTo(36.0)
        }
        
        return stackView
    }
}

//
//  AdminDishesHeaderView.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 24.04.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import UIKit
import SnapKit

extension AdminDishesHeaderView {
    struct Appearance {
        let leadingTrailingInset: CGFloat = 26.0
    }
}

class AdminDishesHeaderView: UICollectionReusableView {
    let appearance = Appearance()
    
    var descriptionTitle: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 20.0)
        label.textAlignment = .left
        label.text = "Description"
        label.sizeToFit()
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textSecondary
        label.font = .font(.regular, size: 14.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var dishesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 20.0)
        label.textAlignment = .left
        label.text = "Dishes"
        label.sizeToFit()
        return label
    }()
    
    private lazy var descriptionDividerView: UIView = {
        BaseViewController.dividerView
    }()
    
    private lazy var dishesDividerView: UIView = {
        BaseViewController.dividerView
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupUI() {
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        [descriptionTitle,
         descriptionLabel,
         dishesLabel,
         descriptionDividerView,
         dishesDividerView
        ].forEach { addSubview($0) }
    }
    
    private func makeConstraints() {
        
        descriptionTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
            make.top.equalToSuperview().inset(18.0)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitle.snp.bottom).offset(14.0)
            make.leading.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        dishesLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(18.0)
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        descriptionDividerView.snp.makeConstraints { make in
            make.leading.equalTo(descriptionTitle.snp.trailing).offset(13.0)
            make.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
            make.centerY.equalTo(descriptionTitle)
        }
        
        dishesDividerView.snp.makeConstraints { make in
            make.leading.equalTo(dishesLabel.snp.trailing).offset(13.0)
            make.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
            make.centerY.equalTo(dishesLabel.snp.centerY)
        }
    }
    
    
    func updateText(text: String) {
        descriptionLabel.text = text
        descriptionLabel.sizeToFit()
    }
}

//
//  AdminProfitsHeaderView.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 04.04.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import SnapKit
import UIKit

extension AdminProfitsHeaderView {
    struct Appearance {
        let leadingTrailingInset: CGFloat = 26.0
    }
}

class AdminProfitsHeaderView: UIView {
    let appearance = Appearance()
    
    var profitsTapped: (() -> Void)?
    
    private lazy var profitsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Total Profits of your restaurant"
        label.textColor = .textSecondary
        label.font = .font(.regular, size: 14.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var coinsImageView: UIImageView = {
        let imageView = UIImageView(image: .greenCoins)
        imageView.contentMode = .scaleAspectFit
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapProfitsView(_:)))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    @objc func didTapProfitsView(_ sender: UITapGestureRecognizer) {
        profitsTapped?()
    }
    
    var profitsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .background
        label.font = .font(.extraBold, size: 32.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var updatesLabel: UILabel = {
        let label = UILabel()
        label.text = "Successful Orders"
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 20.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var dividerView: UIView = {
        BaseViewController.dividerView
    }()
    
    init() {
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
        [profitsTitleLabel,
         coinsImageView,
         updatesLabel,
         dividerView
        ].forEach { addSubview($0) }
        
        coinsImageView.addSubview(profitsLabel)
    }
    
    private func makeConstraints() {
        
        profitsTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
            make.top.equalToSuperview()
        }
        
        coinsImageView.snp.makeConstraints { make in
            make.top.equalTo(profitsTitleLabel.snp.bottom).offset(11.0)
            make.leading.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
            make.height.equalTo(131.0)
        }
        
        profitsLabel.snp.makeConstraints { make in
            make.center.equalTo(coinsImageView)
        }
        
        updatesLabel.snp.makeConstraints { make in
            make.top.equalTo(coinsImageView.snp.bottom).offset(41.0)
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        dividerView.snp.makeConstraints { make in
            make.centerY.equalTo(updatesLabel)
            make.leading.equalTo(updatesLabel.snp.trailing).offset(13.0)
            make.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
            make.bottom.lessThanOrEqualToSuperview().inset(40.0)
        }
    }
}


//
//  AdminTableHeaderView.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 04.04.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import UIKit
import SnapKit

extension AdminTableHeaderView {
    struct Appearance {
        let leadingTrailingInset: CGFloat = 26.0
    }
}

class AdminTableHeaderView: UIView {
    let appearance = Appearance()
    
    private lazy var profitsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Here’s your profit for today"
        label.textColor = .background
        label.font = .font(.regular, size: 14.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var coinsImageView: UIImageView = {
        let imageView = UIImageView(image: .blackCoins)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var profitsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .background
        label.font = .font(.extraBold, size: 32.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var blackViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .textPrimary
        return view
    }()
    
    private lazy var newOrdersLabel: UILabel = {
        let label = UILabel()
        label.text = "New Orders"
        label.textColor = .background
        label.font = .font(.extraBold, size: 14.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    lazy var newOrdersCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .background
        label.font = .font(.extraBold, size: 32.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var orangeViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .brandOrange
        return view
    }()
    
   private lazy var cancelledOrdersLabel: UILabel = {
        let label = UILabel()
        label.text = "Cancelled Orders"
        label.textColor = .background
        label.font = .font(.extraBold, size: 14.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    lazy var cancelledOrdersCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .background
        label.font = .font(.extraBold, size: 32.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            blackViewContainer,
            orangeViewContainer
        ])
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = .zero
        stackView.axis = .horizontal
        stackView.layer.cornerRadius = 8.0
        stackView.clipsToBounds = true
        
        return stackView
    }()
    
    lazy var updatesLabel: UILabel = {
        let label = UILabel()
        label.text = "Updates"
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 32.0)
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
        clipsToBounds = false
    }
    
    private func addSubviews() {
        [profitsTitleLabel,
         coinsImageView,
         stackView,
         updatesLabel,
         dividerView
        ].forEach { addSubview($0) }
        
        coinsImageView.addSubview(profitsLabel)
        
        blackViewContainer.addSubview(newOrdersLabel)
        blackViewContainer.addSubview(newOrdersCountLabel)
        orangeViewContainer.addSubview(cancelledOrdersLabel)
        orangeViewContainer.addSubview(cancelledOrdersCountLabel)
    }
    
    private func makeConstraints() {
        
        profitsTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
            make.top.equalToSuperview()
        }
        
        coinsImageView.snp.makeConstraints { make in
            make.top.equalTo(profitsTitleLabel.snp.bottom).offset(11.0)
            make.leading.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
            make.height.equalTo(91)
        }
        
        profitsLabel.snp.makeConstraints { make in
            make.center.equalTo(coinsImageView)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(coinsImageView.snp.bottom).offset(19.0)
            make.leading.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
            make.height.equalTo(95)
        }
        
        blackViewContainer.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
        orangeViewContainer.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
        newOrdersLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(13.0)
            make.centerX.equalToSuperview()
        }
        
        newOrdersCountLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16.0)
            make.centerX.equalToSuperview()
        }
        
        cancelledOrdersLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(13.0)
            make.centerX.equalToSuperview()
        }
        
        cancelledOrdersCountLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16.0)
            make.centerX.equalToSuperview()
        }
        
        updatesLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(32.0)
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

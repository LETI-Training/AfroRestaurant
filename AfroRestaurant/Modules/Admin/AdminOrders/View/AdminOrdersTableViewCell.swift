//
//  AdminOrdersTableViewCell.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 10.05.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import UIKit
import SnapKit

extension AdminOrdersTableViewCell {
    
    struct Appearance {
        let leadingTrailingInset: CGFloat = 26.0
    }
    
    struct ViewModel {
        let quantity: Int
        let dishName: String
        let price: Double
        let orderType: AdminAnalyticsDataBaseService.OrderStatus
    }
    
}

class AdminOrdersTableViewCell: UITableViewCell {
    
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            let priceString = String(format: "%.2f", viewModel.price)
            actionLabel.text = "Qty:\(viewModel.quantity). - \(viewModel.dishName)"
            priceLabel.text = "+RUB \(priceString)"
            
            switch viewModel.orderType {
            case .delivered:
                actionLabel.textColor = .textSecondary
                priceLabel.textColor = .brandGreen
            case .cancelled:
                actionLabel.textColor = .red
                priceLabel.textColor = .red
            case .created:
                actionLabel.textColor = .textSecondary
                priceLabel.textColor = .brandOrange
            }
        }
    }
    
    private let appearance = Appearance()
    
    private lazy var actionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textSecondary
        label.font = .font(.extraBold, size: 14.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .brandGreen
        label.font = .font(.regular, size: 14.0)
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }()
    
    private lazy var dividerView: UIView = {
        BaseViewController.dividerView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        addSubviews()
        backgroundColor = .clear
        makeConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(priceLabel)
        contentView.addSubview(actionLabel)
        contentView.addSubview(dividerView)
    }
    
    private func makeConstraints() {
        actionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
            make.trailing.equalTo(priceLabel.snp.leading)
            make.centerY.equalToSuperview()
        }
        
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        dividerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
            make.bottom.equalToSuperview()
        }
    }
}

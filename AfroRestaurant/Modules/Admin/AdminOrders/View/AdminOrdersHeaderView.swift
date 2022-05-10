//
//  AdminOrdersHeaderView.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 10.05.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import SnapKit
import UIKit

extension AdminOrdersHeaderView {
    struct Appearance {
        let leadingTrailingInset: CGFloat = 26.0
    }
    
    struct ViewModel {
        let dateString: String
        let orderNumber: String
        let orderStatus: AdminAnalyticsDataBaseService.OrderStatus
        let userType: UserType
        let userDetails: ConsumerDataBaseService.UserDetails
        let cancelOrderButtonTapped: (_ viewModel: ViewModel) -> Void
        let deliverButtonTapped: (_ viewModel: ViewModel) -> Void
    }
    
    enum UserType {
        case consumer
        case admin
    }
}

class AdminOrdersHeaderView: UITableViewCell {
    let appearance = Appearance()
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            orderNumberLabel.text = "#Order: " + viewModel.orderNumber
            dateLabel.text = viewModel.dateString
            usernameLabel.text = "User: " + viewModel.userDetails.userName
            addressLabel.text = "Address: " + viewModel.userDetails.address
            phoneNumberLabel.text = "PhoneNumber: " + viewModel.userDetails.phoneNumber
            
            switch viewModel.orderStatus {
            case .delivered:
                statusLabel.textColor = .brandGreen
                statusLabel.text = "Order Status: This order has been delivered"
                cancelButton.isHidden = true
                deliveredButton.isHidden = true
                cancelButton.snp.updateConstraints { make in
                    make.height.equalTo(0.0)
                }
            case .cancelled:
                statusLabel.textColor = .red
                statusLabel.text = "Order Status: This order was cancelled"
                cancelButton.isHidden = true
                deliveredButton.isHidden = true
                cancelButton.snp.updateConstraints { make in
                    make.height.equalTo(0.0)
                }
            case .created:
                cancelButton.isHidden = false
                deliveredButton.isHidden = false
                cancelButton.snp.updateConstraints { make in
                    make.height.equalTo(50.0)
                }
                statusLabel.textColor = .brandOrange
                statusLabel.text = "Order Status: This order is awaiting delivery"
            }
            
            switch viewModel.userType {
            case .consumer:
                deliveredButton.isHidden = true
                cancelButton.snp.updateConstraints { make in
                    make.trailing.equalTo(self.snp.trailing).inset(appearance.leadingTrailingInset)
                }
            case .admin:
                cancelButton.snp.updateConstraints { make in
                    make.trailing.equalTo(self.snp.centerX).offset(-5.0)
                }
            }
        }
    }
    
    private lazy var orderNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 25.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Total Profits of your restaurant"
        label.textColor = .textSecondary
        label.font = .font(.regular, size: 14.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textSecondary
        label.font = .font(.regular, size: 14.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textSecondary
        label.font = .font(.regular, size: 14.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textSecondary
        label.font = .font(.regular, size: 14.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.bold, size: 14.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Cancel Order", for: .normal)
        button.setTitleColor(.background, for: .normal)
        button.backgroundColor = .red
        button.titleLabel?.font = .font(.bold, size: 17.0)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        button.sizeToFit()
        return button
    }()
    
    private lazy var deliveredButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Order Delivered", for: .normal)
        button.setTitleColor(.background, for: .normal)
        button.backgroundColor = .brandGreen
        button.titleLabel?.font = .font(.bold, size: 17.0)
        button.addTarget(self, action: #selector(deliveredButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        button.sizeToFit()
        return button
    }()
    
    @objc private func cancelButtonTapped() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.cancelOrderButtonTapped(viewModel)
    }
    
    @objc private func deliveredButtonTapped() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.deliverButtonTapped(viewModel)
    }
    
    private lazy var dividerView: UIView = {
        BaseViewController.dividerView
    }()
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        [orderNumberLabel,
         dateLabel,
         statusLabel,
         usernameLabel,
         addressLabel,
         phoneNumberLabel,
         cancelButton,
         deliveredButton
        ].forEach { contentView.addSubview($0) }
    }
    
    private func makeConstraints() {
        
        orderNumberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
            make.top.equalToSuperview().inset(10.0)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(orderNumberLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(15.0)
            make.leading.equalTo(self.snp.leading).inset(appearance.leadingTrailingInset)
            make.trailing.equalTo(self.snp.centerX).offset(-5.0)
            make.height.equalTo(50.0)
            make.bottom.lessThanOrEqualToSuperview().inset(10.0)
        }
        
        deliveredButton.snp.makeConstraints { make in
            make.top.equalTo(cancelButton)
            make.trailing.equalTo(self.snp.trailing).inset(appearance.leadingTrailingInset)
            make.leading.equalTo(self.snp.centerX).offset(5.0)
            make.height.equalTo(50.0)
        }
    }
}



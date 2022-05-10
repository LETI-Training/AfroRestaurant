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
        let userDetails: ConsumerDataBaseService.UserDetails
        let cancelOrderButtonTapped: (_ viewModel: ViewModel) -> Void
        let deleteButtonTapped: (_ viewModel: ViewModel) -> Void
    }
}

class AdminOrdersHeaderView: UIView {
    let appearance = Appearance()
    let viewModel: ViewModel
    
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
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel Order", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = .font(.bold, size: 17.0)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.sizeToFit()
        return button
    }()
    
    private lazy var deliveredButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Order Delivered", for: .normal)
        button.setTitleColor(.brandGreen, for: .normal)
        button.titleLabel?.font = .font(.bold, size: 17.0)
        button.addTarget(self, action: #selector(deliveredButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.sizeToFit()
        return button
    }()
    
    @objc private func cancelButtonTapped() {
        viewModel.cancelOrderButtonTapped(viewModel)
    }
    
    @objc private func deliveredButtonTapped() {
        viewModel.deleteButtonTapped(viewModel)
    }
    
    private lazy var dividerView: UIView = {
        BaseViewController.dividerView
    }()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupUI() {
        addSubviews()
        updateUI()
        makeConstraints()
    }
    
    func updateUI() {
        orderNumberLabel.text = "#Order: " + viewModel.orderNumber
        dateLabel.text = viewModel.dateString
        usernameLabel.text = "User: " + viewModel.userDetails.userName
        addressLabel.text = "Address: " + viewModel.userDetails.address
        phoneNumberLabel.text = "PhoneNumber: " + viewModel.userDetails.phoneNumber
    }
    
    private func addSubviews() {
        [orderNumberLabel,
         dateLabel,
         usernameLabel,
         addressLabel,
         phoneNumberLabel,
         cancelButton,
         deliveredButton
        ].forEach { addSubview($0) }
    }
    
    private func makeConstraints() {
        
        orderNumberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
            make.top.equalToSuperview()
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
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom)
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
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}



//
//  CartPriceLabelCell.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 10.05.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import UIKit
import SnapKit

extension CartPriceLabelCell {
    
    struct Appearance {
    }
    
    struct ViewModel {
        let totalAmount: Double
    }
}

class CartPriceLabelCell: UITableViewCell {

    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            priceLabel.text = "RUB " + String(format: "%.2f", viewModel.totalAmount)
        }
    }
    
    private let appearance = Appearance()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 16.0)
        label.text = "TOTAL:"
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .brandGreen
        label.font = .font(.extraBold, size: 16.0)
        label.textAlignment = .left
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
        contentView.addSubview(totalLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(dividerView)
    }
    
    private func makeConstraints() {
        totalLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(13.0)
            make.leading.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(13.0)
            make.trailing.equalToSuperview()
        }
        
        dividerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}



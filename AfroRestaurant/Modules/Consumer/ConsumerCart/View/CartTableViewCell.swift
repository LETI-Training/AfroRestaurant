//
//  CartTableViewCell.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 10.05.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import UIKit
import SnapKit

extension CartTableViewCell {
    
    struct Appearance {
        let leadingTrailingInset: CGFloat = 26.0
    }
    
    struct ViewModel {
        let image: UIImage?
        let name: String
        let calories: Int
        let amount: Double
        let quantity: Int
        let stepperChanged: (_ count: Int, _ viewModel: ViewModel) -> Void
        let deleteButtonTapped: (_ viewModel: ViewModel) -> Void
    }
}

class CartTableViewCell: UITableViewCell {

    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            dishImageView.image = viewModel.image
            dishNameLabel.text = viewModel.name
            caloriesLabel.text = "\(viewModel.calories) cal."
            priceLabel.text = "RUB " + String(format: "%.2f", viewModel.amount)
            stepper.value = Double(viewModel.quantity)
            quantityLabel.text = "Qty: \(viewModel.quantity)"
        }
    }
    
    private let appearance = Appearance()
    
    private lazy var dishImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private lazy var dishNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 16.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var caloriesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textSecondary
        label.font = .font(.mediumItalic, size: 12.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textSecondary
        label.font = .font(.mediumItalic, size: 12.0)
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
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.background, for: .normal)
        button.setImage(.delete, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.tintColor = .black
        button.sizeToFit()
        return button
    }()
    
    private lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 0
        stepper.addTarget(self, action: #selector(stepperChanged), for: .valueChanged)
        return stepper
    }()
    
    private lazy var dividerView: UIView = {
        BaseViewController.dividerView
    }()
    
    @objc private func deleteButtonTapped() {
        guard let viewModel = viewModel else { return }
        viewModel.deleteButtonTapped(viewModel)
    }
    
    @objc private func stepperChanged() {
        guard let viewModel = viewModel else { return }
        viewModel.stepperChanged(Int(stepper.value), viewModel)
    }
    
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
        contentView.addSubview(dishImageView)
        contentView.addSubview(dishNameLabel)
        contentView.addSubview(caloriesLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(deleteButton)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(stepper)
        contentView.addSubview(dividerView)
    }
    
    private func makeConstraints() {
        dishImageView.snp.makeConstraints { make in
            make.height.width.equalTo(112.0)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        dishNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(dishImageView.snp.trailing).offset(11.0)
            make.trailing.equalTo(deleteButton.snp.leading).offset(-5.0)
            make.top.equalTo(dishImageView)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.height.width.equalTo(18.0)
            make.top.equalTo(dishImageView)
        }

        caloriesLabel.snp.makeConstraints { make in
            make.top.equalTo(dishNameLabel.snp.bottom).offset(5.0)
            make.leading.equalTo(dishImageView.snp.trailing).offset(11.0)
        }
        
        quantityLabel.snp.makeConstraints { make in
            make.bottom.equalTo(priceLabel.snp.top).offset(-5.0)
            make.leading.equalTo(dishImageView.snp.trailing).offset(11.0)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(dishImageView.snp.trailing).offset(11.0)
            make.trailing.equalTo(stepper.snp.leading).offset(-5.0)
            make.bottom.equalTo(dishImageView)
        }
        
        stepper.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(dishImageView)
        }
        
        dividerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}


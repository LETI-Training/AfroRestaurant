//
//  DishesCollectionViewCell.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 24.04.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import UIKit

extension DishesCollectionViewCell {
    struct Appearance {
        
    }
    
    enum ButtonType {
        case cart(isAdded: Bool)
        case delete
        case like(isLiked: Bool)
    }
    
    struct ViewModel {
        let type: ButtonType
        let dishName: String
        let rating: Double
        let calories: Int
        let price: Double
        let image: UIImage
        let buttonTapHandler: (ViewModel) -> Void
    }
}


class DishesCollectionViewCell: UICollectionViewCell {
    
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            dishImageView.image = viewModel.image
            dishLabel.text = viewModel.dishName
            ratingsLabel.text = String(format: "%.1f", viewModel.rating)
            priceLabel.text = "RUB " + String(format: "%.1f", viewModel.price)
            caloriesLabel.text = String(format: "%.1f", viewModel.price) + "Cal."
            
            switch viewModel.type {
                
            case .cart(isAdded: _):
                break
            case .delete:
                deleteButton.setImage(.delete, for: .normal)
            case .like(isLiked: _):
                break
            }
        }
    }
    
    private let appearance = Appearance()
    
    private lazy var dishImageView: UIImageView = {
        let image =  UIImageView(frame: .zero)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var ratingsImageView: UIImageView = {
        let image =  UIImageView(image: .star)
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var ratingsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .background
        label.font = .font(.regular, size: 10.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var bottomContainerView: UIView = {
       UIView()
    }()
    
    var dishLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 12.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    var caloriesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textSecondary
        label.font = .font(.mediumItalic, size: 10.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .brandGreen
        label.font = .font(.extraBold, size: 10.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            caloriesLabel,
            priceLabel
        ])
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 3.0
        stackView.axis = .horizontal
        stackView.clipsToBounds = true
        
        return stackView
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .red
        button.setImage(.delete, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.sizeToFit()
        return button
    }()
    
    @objc private func deleteButtonTapped() {
        guard let viewModel = viewModel else { return }
        viewModel.buttonTapHandler(viewModel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        addSubviews()
        makeConstraints()
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(red: 0.846, green: 0.846, blue: 0.846, alpha: 1).cgColor
        layer.cornerRadius = 8.0
        clipsToBounds = true
    }
    
    private func addSubviews() {
        [dishImageView,
         bottomContainerView
        ].forEach { contentView.addSubview($0) }
        
        [dishLabel,
         stackView,
         deleteButton
        ].forEach { bottomContainerView.addSubview($0) }
        
        [ratingsImageView,
         ratingsLabel
        ].forEach { dishImageView.addSubview($0) }
        
    }
    
    private func makeConstraints() {
        
        dishImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(113.0)
        }
        
        ratingsLabel.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(4.0)
        }
        
        ratingsImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(4)
            make.width.height.equalTo(10.0)
            make.trailing.equalTo(ratingsLabel.snp.leading).offset(-2.0)
        }
        
        bottomContainerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(dishImageView.snp.bottom)
        }
        
        dishLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(7.0)
            make.trailing.equalTo(deleteButton.snp.leading).offset(4.0)
        }
        
        stackView.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(7.0)
            make.trailing.equalTo(deleteButton.snp.leading).offset(4.0)
            make.height.equalTo(priceLabel)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
    }
}


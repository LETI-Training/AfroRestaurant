//
//  DishesCollectionViewCell.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 24.04.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import UIKit

extension DishesCollectionViewCell {
    struct Appearance {}
    
    enum ButtonType {
        case delete
        case like(isLiked: Bool)
    }
    
    enum `Type` {
        case `default`
        case withCart(isAdded: Bool)
    }
    
    struct ViewModel {
        let type: Type
        let buttonType: ButtonType
        let dishName: String
        let rating: Double
        let calories: Int
        let price: Double
        let image: UIImage?
        let buttonTapHandler: (ViewModel) -> Void
        let cartButtonTapped: ((_ model: ViewModel) -> Void)?
        let buyNowButtonTapped: ((_ model: ViewModel) -> Void)?
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
            caloriesLabel.text = String(format: "%d", viewModel.calories) + " Cal."
            
            switch viewModel.buttonType {
            case .delete:
                iconButton.backgroundColor = .red
                iconButton.setImage(.delete, for: .normal)
            case .like(isLiked: let isLiked):
                iconButton.backgroundColor = isLiked
                ? .brandOrange
                : UIColor(red: 0.846, green: 0.846, blue: 0.846, alpha: 1)
                iconButton.setImage(.favoriteWhite, for: .normal)
            }
            
            switch viewModel.type {
            case .default:
                buyNowNutton.isHidden = true
                cartButton.isHidden = true
            case .withCart(isAdded: let isAdded):
                cartButton.isHidden = false
                cartButton.backgroundColor = isAdded
                ? .brandGreen
                : .black
                buyNowNutton.isHidden = false
            }
        }
    }
    
    private let appearance = Appearance()
    
    private lazy var topContainerView: UIView = {
       UIView()
    }()
    
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
    
    private lazy var ratingContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        return view
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
        label.textAlignment = .right
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
    
    private lazy var iconButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.setImage(.delete, for: .normal)
        button.addTarget(self, action: #selector(iconButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.sizeToFit()
        return button
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.cartWhite, for: .normal)
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.sizeToFit()
        button.layer.cornerRadius = 36 / 2
        return button
    }()
    
    private lazy var buyNowNutton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.buyNow, for: .normal)
        button.addTarget(self, action: #selector(buyNowButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.sizeToFit()
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dishImageView.image = nil
        iconButton.isHighlighted = false
        cartButton.isHighlighted = false
        buyNowNutton.isHighlighted = false
        iconButton.isSelected = false
        cartButton.isSelected = false
        buyNowNutton.isSelected = false
    }
    
    @objc private func iconButtonTapped() {
        guard let viewModel = viewModel else { return }
        viewModel.buttonTapHandler(viewModel)
    }
    
    @objc private func cartButtonTapped() {
        guard let viewModel = viewModel else { return }
        viewModel.cartButtonTapped?(viewModel)
    }
    
    @objc private func buyNowButtonTapped() {
        guard let viewModel = viewModel else { return }
        viewModel.buyNowButtonTapped?(viewModel)
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
        topContainerView.layer.borderWidth = 1.0
        topContainerView.layer.borderColor = UIColor(red: 0.846, green: 0.846, blue: 0.846, alpha: 1).cgColor
        topContainerView.layer.cornerRadius = 8.0
        clipsToBounds = true
        topContainerView.clipsToBounds = true
    }
    
    private func addSubviews() {
        [topContainerView,
         cartButton,
         buyNowNutton
        ].forEach { contentView.addSubview($0) }
        
        [dishImageView,
         bottomContainerView,
        ].forEach { topContainerView.addSubview($0) }
        
        [dishLabel,
         stackView,
         iconButton
        ].forEach { bottomContainerView.addSubview($0) }
        
        dishImageView.addSubview(ratingContainerView)
        [ratingsImageView,
         ratingsLabel
        ].forEach { ratingContainerView.addSubview($0) }
    }
    
    private func makeConstraints() {
        
        topContainerView.snp.makeConstraints { make in
            make.height.equalTo(158.0)
            make.leading.trailing.top.equalToSuperview()
        }
        
        dishImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(113.0)
        }
        
        ratingContainerView.snp.makeConstraints { make in
            make.height.equalTo(20.0)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        ratingsLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(4.0)
            make.centerY.equalToSuperview()
        }
        
        ratingsImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(10.0)
            make.trailing.equalTo(ratingsLabel.snp.leading).offset(-2.0)
        }
        
        bottomContainerView.snp.makeConstraints { make in
            make.height.equalTo(45.0)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(dishImageView.snp.bottom)
        }
        
        dishLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(7.0)
            make.trailing.equalTo(iconButton.snp.leading).offset(4.0)
        }
        
        stackView.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(7.0)
            make.trailing.equalTo(iconButton.snp.leading).offset(-4.0)
            make.height.equalTo(priceLabel)
        }
        
        iconButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
        
        cartButton.snp.makeConstraints { make in
            make.top.equalTo(bottomContainerView.snp.bottom).offset(8.0)
            make.leading.equalToSuperview()
            make.width.height.equalTo(36)
        }
        
        buyNowNutton.snp.makeConstraints { make in
            make.centerY.height.equalTo(cartButton)
            make.trailing.equalToSuperview()
            make.leading.equalTo(cartButton.snp.trailing).offset(9.0)
        }
    }
}


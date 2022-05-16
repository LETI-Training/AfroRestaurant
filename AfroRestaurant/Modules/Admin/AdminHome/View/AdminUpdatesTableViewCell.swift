//
//  AdminUpdatesTableViewCell.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 04.04.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import UIKit
import SnapKit

extension AdminUpdatesTableViewCell {
    
    struct Appearance {
        let leadingTrailingInset: CGFloat = 26.0
    }
    
    struct ViewModel {
        let name: String
        let dish: String
        let type: ImageType
    }
    
    enum ImageType {
        case favorite
        case rating(rating: Int)
    }
}

class AdminUpdatesTableViewCell: UITableViewCell {

    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            switch viewModel.type {
            case .favorite:
                actionLabel.text = "\(viewModel.name) added \(viewModel.dish) to favorites"
                iconImageView.image = .favorite
            case .rating(let rating):
                actionLabel.text = "\(viewModel.name) added a \(rating).0 rating for \(viewModel.dish)"
                iconImageView.image = .greenStar
            }
        }
    }
    
    private let appearance = Appearance()
    
    private lazy var userImageView: UIImageView = {
        let image: UIImage = .userIcon.withTintColor(.textSecondary)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .textSecondary
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 31.0 / 2
        return imageView
    }()
    
    private lazy var actionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textSecondary
        label.font = .font(.regular, size: 14.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        contentView.addSubview(userImageView)
        contentView.addSubview(actionLabel)
        contentView.addSubview(iconImageView)
    }
    
    private func makeConstraints() {
        userImageView.snp.makeConstraints { make in
            make.height.width.equalTo(31.0)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        actionLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(7.0)
            make.trailing.equalTo(iconImageView.snp.leading).offset(-20.0)
            make.centerY.equalToSuperview()
        }

        iconImageView.snp.makeConstraints { make in
            make.height.width.equalTo(22.0)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
    }
}

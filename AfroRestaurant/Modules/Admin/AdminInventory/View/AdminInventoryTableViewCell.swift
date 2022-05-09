//
//  AdminInventoryTableViewCell.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 12.04.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import UIKit
import SnapKit

extension AdminInventoryTableViewCell {
    
    struct Appearance {
        let leadingTrailingInset: CGFloat = 26.0
    }
    
    struct ViewModel {
        let categoryName: String
    }
}

class AdminInventoryTableViewCell: UITableViewCell {

    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            categoryLabel.text = viewModel.categoryName
        }
    }
    
    private let appearance = Appearance()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.font = .font(.regular, size: 17.0)
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
        accessoryType = .disclosureIndicator
        addSubviews()
        backgroundColor = .clear
        makeConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(categoryLabel)
        contentView.addSubview(dividerView)
    }
    
    private func makeConstraints() {

        categoryLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
            make.centerY.equalToSuperview()
        }
        
        dividerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
            make.bottom.equalToSuperview()
        }
    }
}



//
//  ConsumerHomeHeaderView.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 09.05.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import UIKit
import SnapKit

extension ConsumerHomeHeaderView {
    struct Appearance {
        let leadingTrailingInset: CGFloat = 26.0
    }
}

class ConsumerHomeHeaderView: UICollectionReusableView {
    let appearance = Appearance()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 20.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var dishesDividerView: UIView = {
        BaseViewController.dividerView
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    override init(frame: CGRect) {
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
    }
    
    private func addSubviews() {
        [
         categoryLabel,
         dishesDividerView
        ].forEach { addSubview($0) }
    }
    
    private func makeConstraints() {
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18.0)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().inset(14.0)
        }
        dishesDividerView.snp.makeConstraints { make in
            make.leading.equalTo(categoryLabel.snp.trailing).offset(13.0)
            make.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
            make.centerY.equalTo(categoryLabel.snp.centerY)
        }
    }
    
    func updateText(text: String) {
        categoryLabel.text = text
    }
}

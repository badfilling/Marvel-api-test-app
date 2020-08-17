//
//  MarvelCharacterCell.swift
//  MarvelApp
//
//  Created by Artur Stepaniuk on 18/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit
import SnapKit

class MarvelCharacterCell: UITableViewCell {
    
    let avatarView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private var onHide: CancelLoadingHandler?


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let textDataStack = UIStackView()
        textDataStack.axis = .vertical
        textDataStack.alignment = .leading
        textDataStack.distribution = .equalSpacing
        textDataStack.addArrangedSubview(nameLabel)
        textDataStack.addArrangedSubview(descriptionLabel)
        
        contentView.addSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(4)
            make.centerY.equalTo(contentView)
            make.size.equalTo(100)
        }
        
        contentView.addSubview(textDataStack)
        textDataStack.snp.makeConstraints { make in
            make.leading.equalTo(avatarView.snp.trailing).offset(8)
            make.top.equalTo(contentView).offset(4)
            make.bottom.equalTo(contentView).offset(-4)
            make.trailing.equalTo(contentView).offset(-4)
            make.height.greaterThanOrEqualTo(avatarView.snp.height)
        }
    }
    
    
    override func prepareForReuse() {
        setNotLoaded()
        onHide?()
    }

    func configure(model: MarvelCharacterCellViewModel) {
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        
        onHide = model.setImage(in: avatarView)
    }
    
    func setNotLoaded() {
        avatarView.image = nil
        nameLabel.text = "Loading..."
        descriptionLabel.text = nil
    }
}

extension MarvelCharacterCell {
    static let estimatedRowHeight: CGFloat = 120
}


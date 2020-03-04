//
//  ChatMessageCell.swift
//  MarvelApp
//
//  Created by Artur Stepaniuk on 21/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ChatMessageCell: UITableViewCell {
    
    let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 4
        return stack
    }()
    
    let messageLabel: UILabel = {
        let padding = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        let label = PaddedUILabel(padding: padding)
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.backgroundColor = .systemTeal
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    
    let senderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("no storyboards")
    }
    
    
    func setupViews() {
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        senderLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerStack)
        containerStack.addArrangedSubview(senderLabel)
        containerStack.addArrangedSubview(messageLabel)
        
        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6))
        }
    }
    
    private func setOwner(to owner: MessageOwner) {
        switch owner {
        case .user:
            containerStack.alignment = .trailing
        case .interlocutor:
            containerStack.alignment = .leading
        }
    }
    
    func configure(with viewModel: ChatMessageCellViewModel) {
        messageLabel.text = viewModel.content
        
        senderLabel.text = viewModel.senderInfo
        setOwner(to: viewModel.sender)
    }
}

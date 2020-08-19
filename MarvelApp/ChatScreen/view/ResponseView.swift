//
//  ResponseView.swift
//  MarvelApp
//
//  Created by Artur Stepaniuk on 24/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

class ResponseView: UIView {
    
    //to vm
    var responses = [
        "Angry kookaburras attack!",
        "Enjoy the summer :]",
        "Uffff"
    ]
    
    var responseHandler: ((String) -> Void)?
    
    override func layoutSubviews() {
        setupViews()
        super.layoutSubviews()
    }
    
    func setupViews() {
        backgroundColor = .systemBackground
        let buttons = prepareButtons()
        let buttonStack = UIStackView()
        buttonStack.axis = .vertical
        buttonStack.distribution = .fillProportionally
        buttonStack.spacing = 5
        buttonStack.alignment = .fill
        for button in buttons {
            buttonStack.addArrangedSubview(button)
        }
        
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    private func prepareButtons() -> [UIButton] {
        var buttons = [UIButton]()
        for response in responses {
            let button = UIButton()
            button.addTarget(self, action: #selector(responseTapped(sender:)), for: .touchUpInside)
            button.setTitle(response, for: .normal)
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
            button.setTitleColor(.systemRed, for: .normal)
            button.titleEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
            button.backgroundColor = .systemTeal
            button.layer.cornerRadius = 4
            buttons.append(button)
            
        }
        return buttons
    }
    
    @objc func responseTapped(sender: UIButton) {
        responseHandler?(sender.titleLabel!.text!)
    }
}

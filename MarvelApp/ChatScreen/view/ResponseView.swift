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
        "Angry kookaburras have invided our city! PLEASE SAVE US!",
        "You're a hero so you should help other people - give me some money pls :]",
        "I want to become as strong as you! What should i eat for breakfast?"
    ]
    
    var responseHandler: ((String) -> Void)?
    
    override func layoutSubviews() {
        setupViews()
        super.layoutSubviews()
    }
    
    func setupViews() {
        
        let scrollView = prepareScrollView()
        
        let buttons = prepareButtons()
        
        var scrollContentSize = CGSize(width: .zero, height: bounds.height)
        for button in buttons {
            button.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(button)
            
            let buttonWidth = totalWidth(for: button)
            scrollContentSize.width += buttonWidth

            let previousView = scrollView.subviews.last { $0 != button && $0 is UIButton } ?? scrollView
            button.snp.makeConstraints { make in
                make.leading.equalTo(previousView.snp.trailing).offset(4)
                make.width.equalTo(buttonWidth)
                make.height.equalTo(bounds.height)
                make.centerY.equalToSuperview()
            }
            
        }
        
        scrollView.contentSize = scrollContentSize
    }
    
    private func prepareScrollView() -> UIScrollView {
        let scrollView = UIScrollView(frame: .zero)
        self.addSubview(scrollView)
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return scrollView
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
    
    private func totalWidth(for button: UIButton) -> CGFloat {
        let insetsWidth = button.titleEdgeInsets.left + button.titleEdgeInsets.right
        let titleWidth = ceil((button.titleLabel?.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0)) ?? .zero).width)
        return insetsWidth + titleWidth
    }
    
    @objc func responseTapped(sender: UIButton) {
        responseHandler?(sender.titleLabel!.text!)
    }
    
}

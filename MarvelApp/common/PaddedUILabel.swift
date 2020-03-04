//
//  PaddedUILabel.swift
//  MarvelApp
//
//  Created by Artur Stepaniuk on 24/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

class PaddedUILabel: UILabel {
    
    let padding: UIEdgeInsets
    init(padding: UIEdgeInsets) {
        self.padding = padding
        super.init(frame: .zero)
        numberOfLines = 0
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += padding.left + padding.right
        contentSize.height += padding.top + padding.bottom
        return contentSize
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

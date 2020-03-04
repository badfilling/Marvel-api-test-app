//
//  MarvelCharacterCellViewModelTests.swift
//  MarvelAppTestsV2
//
//  Created by Artur Stepaniuk on 28/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import XCTest
import Foundation
import UIKit
@testable import MarvelApp

class MarvelCharacterCellViewModelTests: XCTestCase {
    var avatarProvider: MarvelAvatarProviderMock!
    var cellViewModel: MarvelCharacterCellViewModel!
    
    override func setUp() {
        avatarProvider = MarvelAvatarProviderMock()
        cellViewModel = MarvelCharacterCellViewModel(name: "", description: "", imageURL: "", imageProvider: avatarProvider)
    }
    
    func testAvatarProviderIsCalledOnSettingImage() {
        let imageView = UIImageView(frame: .zero)
        cellViewModel.setImage(in: imageView)
        
        XCTAssertEqual(avatarProvider.callingsCounter, 1)
    }
}

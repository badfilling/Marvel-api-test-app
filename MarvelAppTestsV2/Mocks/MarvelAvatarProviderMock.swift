//
//  MarvelAvatarProviderMock.swift
//  MarvelAppTestsV2
//
//  Created by Artur Stepaniuk on 28/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
import UIKit
@testable import MarvelApp

class MarvelAvatarProviderMock: MarvelAvatarProvider {
    var callingsCounter = 0
    func setImage(for url: String, in view: UIImageView) -> CancelLoadingHandler? {
        callingsCounter += 1
        return nil
    }
    
    
}

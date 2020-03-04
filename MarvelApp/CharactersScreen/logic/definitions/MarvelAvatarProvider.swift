//
//  MarvelAvatarProvider.swift
//  MarvelApp
//
//  Created by Artur Stepaniuk on 18/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

protocol MarvelAvatarProvider {
    func setImage(for url: String, in view: UIImageView) -> CancelLoadingHandler?
}

typealias CancelLoadingHandler = (() -> Void)

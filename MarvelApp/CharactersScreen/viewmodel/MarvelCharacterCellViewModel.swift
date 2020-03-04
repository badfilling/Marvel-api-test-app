//
//  MarvelCharacterCellViewModel.swift
//  MarvelApp
//
//  Created by Artur Stepaniuk on 18/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

struct MarvelCharacterCellViewModel {
    let name: String
    let description: String
    let imageURL: String
    let imageProvider: MarvelAvatarProvider
    
    func setImage(in view: UIImageView) -> CancelLoadingHandler? {
        return imageProvider.setImage(for: imageURL, in: view)
    }
}

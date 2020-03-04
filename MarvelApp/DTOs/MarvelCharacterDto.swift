//
//  MarvelCharacterDto.swift
//  MarvelApp
//
//  Created by Artur Stepaniuk on 18/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

struct MarvelCharacterDto: Decodable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: CharacterThumbnailDto?
}

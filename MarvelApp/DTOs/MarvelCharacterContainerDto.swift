//
//  MarvelCharacterContainerDto.swift
//  MarvelApp
//
//  Created by Artur Stepaniuk on 18/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

struct MarvelCharacterContainerDto: Decodable {
    var offset: Int?
    var limit: Int?
    var total: Int?
    var count: Int?
    var results: [MarvelCharacterDto]?
}

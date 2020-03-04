//
//  CharacterThumbnailDto.swift
//  MarvelApp
//
//  Created by Artur Stepaniuk on 18/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

struct CharacterThumbnailDto: Decodable {
    let path: String
    let imageExtension: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case imageExtension = "extension"
    }
    
    func convertToURL() -> String {
        var url = ""
        url.append(path)
        url.append("/standard_medium")
        url.append(".\(imageExtension)")
        return url
    }
}

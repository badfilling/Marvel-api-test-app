//
//  MessageOwner.swift
//  MarvelApp
//
//  Created by Artur Stepaniuk on 21/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
enum MessageOwner: String {
    case user
    case interlocutor
    
    static func create(from value: String) -> Self {
        switch value {
        case "interlocutor":
            return .interlocutor
        default:
            return .user
        }
    }
}

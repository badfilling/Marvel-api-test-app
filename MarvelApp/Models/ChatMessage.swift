//
//  ChatMessage.swift
//  MarvelApp
//
//  Created by Artur Stepaniuk on 20/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

struct ChatMessage: Equatable {
    let owner: MessageOwner
    let content: String
    let timestamp: Date
}

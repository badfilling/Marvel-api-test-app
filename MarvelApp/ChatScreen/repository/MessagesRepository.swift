//
//  MessagesRepository.swift
//  MarvelApp
//
//  Created by Artur Stepaniuk on 21/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

protocol MessagesRepository {
    func get(offset: Int, ascending: Bool) -> [ChatMessage]
    func add(message: ChatMessage) -> Bool
    func messagesCount() -> Int
    
    
    var associatedCharacterId: Int { get set }
    var batchSize: Int { get }
}

extension MessagesRepository {
    func get(offset: Int, ascending: Bool = false) -> [ChatMessage] {
        return get(offset: offset, ascending: ascending)
    }
}

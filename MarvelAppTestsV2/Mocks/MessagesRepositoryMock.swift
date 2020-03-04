//
//  MessagesRepositoryMock.swift
//  MarvelAppTestsV2
//
//  Created by Artur Stepaniuk on 28/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
@testable import MarvelApp

class MessagesRepositoryMock: MessagesRepository {
    var returnOnAdd = false
    var _messagesCount = 0
    var getCalledCounter = 0
    var addCalledCounter = 0
    var messagesToReturnOnGet = [ChatMessage]()
    
    func get(offset: Int, ascending: Bool) -> [ChatMessage] {
        getCalledCounter += 1
        return messagesToReturnOnGet
    }
    
    func add(message: ChatMessage) -> Bool {
        addCalledCounter += 1
        return returnOnAdd
    }
    
    func messagesCount() -> Int {
        return _messagesCount
    }
    
    var associatedCharacterId: Int = 0
    
    var batchSize: Int = 0
    
}

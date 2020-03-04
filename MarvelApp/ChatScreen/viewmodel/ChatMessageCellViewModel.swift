//
//  ChatMessageCellViewModel.swift
//  MarvelApp
//
//  Created by Artur Stepaniuk on 21/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

struct ChatMessageCellViewModel {
    let content: String
    let sender: MessageOwner
    var senderInfo: String {
        get {
            return "\(ownerDisplayName), \(formattedDate)"
        }
    }
    
    init(content: String, sender: MessageOwner, ownerDisplayName: String, date: Date) {
        self.content = content
        self.sender = sender
        self.ownerDisplayName = ownerDisplayName
        self.date = date
    }
    
    private let ownerDisplayName: String
    private let date: Date
    private var formattedDate: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            return dateFormatter.string(from: date)
        }
    }
}

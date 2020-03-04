//
//  CharacterChatViewModel.swift
//  MarvelApp
//
//  Created by Artur Stepaniuk on 21/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

class CharacterChatViewModel {
    
    let messagesRepository: MessagesRepository
    let characterName: String
    var loadedMessages: [ChatMessage]
    var totalMessagesCount: Int
    
    weak var delegate: MessagesAddedDelegate?
    
    init(messagesRepository: MessagesRepository, characterName: String) {
        self.messagesRepository = messagesRepository
        self.characterName = characterName
        loadedMessages = messagesRepository.get(offset: 0)
        totalMessagesCount = messagesRepository.messagesCount()
    }
    
    func loadMessages() {
        loadedMessages.append(contentsOf: messagesRepository.get(offset: loadedMessages.count))
    }
    
    func getCellModel(for indexPath: IndexPath) -> ChatMessageCellViewModel {
        
        let message = loadedMessages[indexPath.row]
        return ChatMessageCellViewModel(content: message.content, sender: message.owner, ownerDisplayName: message.owner == .user ? CharacterChatViewModel.userDisplayName : characterName, date: message.timestamp)
    }
    
    func addMessage(content: String, addingCharacterResponse: Bool = true) {
        let userMessage = ChatMessage(owner: .user, content: content, timestamp: Date())
        
        add(chatMessage: userMessage)
        
        if addingCharacterResponse {
            addCharacterResponse()
        }
    }
    
    private func add(chatMessage: ChatMessage) {
        loadedMessages.insert(chatMessage, at: 0)
        let _ = messagesRepository.add(message: chatMessage)
        delegate?.messagesAdded(at: [IndexPath(row: 0, section: 0)])
    }
    
    private func addCharacterResponse() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            let characterMessage = ChatMessage(owner: .interlocutor, content: "Response FROM MARVEL ITSLEF", timestamp: Date())
            self?.add(chatMessage: characterMessage)
        }
    }
}

extension CharacterChatViewModel {
    static let userDisplayName = "Me"
}

protocol MessagesAddedDelegate: class {
    func messagesAdded(at indexes: [IndexPath])
}

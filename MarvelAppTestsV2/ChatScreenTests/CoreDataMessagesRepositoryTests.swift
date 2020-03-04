//
//  CoreDataMessagesRepositoryTests.swift
//  MarvelAppTestsV2
//
//  Created by Artur Stepaniuk on 28/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
import CoreData
import XCTest
@testable import MarvelApp

class CoreDataMessagesRepositoryTests: XCTestCase {
    var messagesRepository: CoreDataMessagesRepository!
//    var persistentContainer: NSPersistentContainer!
    var coreDataContext: NSManagedObjectContext!
    var associatedCharacterId = 1
    var messageEntityName = "ChatMessageEntity"
    
    override func setUp() {
        coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        messagesRepository = CoreDataMessagesRepository(coreDataContext: coreDataContext, characterId: associatedCharacterId)
    }
    
    override func tearDown() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: messageEntityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try! coreDataContext.execute(batchDeleteRequest)
        try! coreDataContext.save()
    }
    
    func testExistingMessagesRetrievedCorrectly() {
        let chatMessage1 = ChatMessage(owner: .interlocutor, content: "one", timestamp: Date())
        createMessage(for: associatedCharacterId, from: chatMessage1)
        
        let chatMessage2 = ChatMessage(owner: .user, content: "two", timestamp: Date())
        createMessage(for: associatedCharacterId, from: chatMessage2)
        
        let messagesFromRepo = messagesRepository.get(offset: 0, ascending: false)
        
        XCTAssertEqual(chatMessage2, messagesFromRepo[0])
        XCTAssertEqual(chatMessage1, messagesFromRepo[1])
    }
    
    func testOnlyMessagesWithRightCharacterIdAreRetrieved() {
        let chatMessage1 = ChatMessage(owner: .interlocutor, content: "one", timestamp: Date())
        createMessage(for: associatedCharacterId, from: chatMessage1)
        
        let chatMessage2 = ChatMessage(owner: .user, content: "two", timestamp: Date())
        createMessage(for: associatedCharacterId + 1, from: chatMessage2)
        
        let messagesFromRepo = messagesRepository.get(offset: 0, ascending: false)
        
        XCTAssertEqual(chatMessage1, messagesFromRepo[0])
        XCTAssertEqual(messagesFromRepo.count, 1)
    }
    
    func testMessageIsAddedCorrectly() {
        let chatMessage1 = ChatMessage(owner: .interlocutor, content: "one", timestamp: Date())
        
        let _ = messagesRepository.add(message: chatMessage1)
        
        let message = getMessages(for: associatedCharacterId)[0]
        
        XCTAssertEqual(chatMessage1.content, message.content!)
        XCTAssertEqual(chatMessage1.owner.rawValue, message.owner!)
        XCTAssertEqual(chatMessage1.timestamp, message.timestamp!)
    }
    
    func testMessagesCountFiltersByAssociatedCharacterId() {
        let chatMessage1 = ChatMessage(owner: .interlocutor, content: "one", timestamp: Date())
        createMessage(for: associatedCharacterId, from: chatMessage1)
        
        let chatMessage2 = ChatMessage(owner: .user, content: "two", timestamp: Date())
        createMessage(for: associatedCharacterId + 1, from: chatMessage2)
        
        XCTAssertEqual(messagesRepository.messagesCount(), 1)
    }
    
    
    private func createMessage(for characterId: Int, from message: ChatMessage) {
        let entity: ChatMessageEntity = NSEntityDescription.insertNewObject(forEntityName: messageEntityName, into: coreDataContext) as! ChatMessageEntity
        
        entity.characterId = Int32(characterId)
        entity.content = message.content
        entity.owner = message.owner.rawValue
        entity.timestamp = message.timestamp
        
        try! coreDataContext.save()
    }
    
    private func getMessages(for characterId: Int) -> [ChatMessageEntity] {
        let fetchRequest: NSFetchRequest<ChatMessageEntity> = ChatMessageEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "characterId == %d", associatedCharacterId)
        var messages = [ChatMessageEntity]()
        
        do {
            let messagesEntities = try coreDataContext.fetch(fetchRequest)
            messages.append(contentsOf: messagesEntities)
            
        } catch {
            print("error on fetching messages for characterId = \(associatedCharacterId)")
        }
        return messages
    }
}

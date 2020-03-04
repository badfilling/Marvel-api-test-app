//
//  CoreDataMessagesRepository.swift
//  MarvelApp
//
//  Created by Artur Stepaniuk on 21/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import CoreData

class CoreDataMessagesRepository: MessagesRepository {
    private let coreDataContext: NSManagedObjectContext
    
    var batchSize: Int = 20
    var associatedCharacterId: Int
    init(coreDataContext: NSManagedObjectContext, characterId: Int) {
        self.coreDataContext = coreDataContext
        associatedCharacterId = characterId
    }
    
    func get(offset: Int, ascending: Bool = false) -> [ChatMessage] {
        let fetchRequest: NSFetchRequest<ChatMessageEntity> = ChatMessageEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "characterId == %d", associatedCharacterId)
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "timestamp", ascending: ascending)]
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = batchSize
        var messages = [ChatMessage]()
        
        do {
            let messagesEntities = try coreDataContext.fetch(fetchRequest)
            messages = messagesEntities.map { ChatMessage(owner: MessageOwner.create(from: $0.owner!), content: $0.content!, timestamp: $0.timestamp!) }
            
        } catch {
            print("error on fetching messages for characterId = \(associatedCharacterId)")
        }
    
        return messages
    }
    
    func add(message: ChatMessage) -> Bool {
        let entity: ChatMessageEntity = NSEntityDescription.insertNewObject(forEntityName: "ChatMessageEntity", into: coreDataContext) as! ChatMessageEntity
        
        entity.characterId = Int32(associatedCharacterId)
        entity.content = message.content
        entity.owner = message.owner.rawValue
        entity.timestamp = message.timestamp
        do {
            try coreDataContext.save()
            return true
        } catch {
            return false
        }
    }
    
    func messagesCount() -> Int {
        let fetchRequest: NSFetchRequest<ChatMessageEntity> = ChatMessageEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "characterId == %d", associatedCharacterId)
        do {
            return try coreDataContext.count(for: fetchRequest)
        } catch {
            print("error on fetching messages for characterId = \(associatedCharacterId)")
        }
        return 0
    }
}

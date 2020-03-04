//
//  CharacterChatViewModelTests.swift
//  MarvelAppTestsV2
//
//  Created by Artur Stepaniuk on 28/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import XCTest
@testable import MarvelApp

class CharacterChatViewModelTests: XCTestCase {
    var viewModel: CharacterChatViewModel!
    var messagesRepository: MessagesRepositoryMock!
    var characterName: String = "HeroTest"
    var delegateCalledCounter = 0
    
    override func setUp() {
        messagesRepository = MessagesRepositoryMock()
        viewModel = CharacterChatViewModel(messagesRepository: messagesRepository, characterName: characterName)
        viewModel.delegate = self
    }
    
    func testMessagesAreLoadedOnInit() {
        XCTAssertEqual(messagesRepository.getCalledCounter, 1)
    }
    
    func testMessageRepositoryIsCalledOnLoadMessages() {
        messagesRepository.getCalledCounter = 0
        viewModel.loadMessages()
        
        XCTAssertEqual(messagesRepository.getCalledCounter, 1)
    }
    
    func testLoadedMessagesAreAddedToViewModel() {
        messagesRepository.messagesToReturnOnGet = [createMessage(with: "a"), createMessage(with: "b")]
        viewModel.loadedMessages.append(createMessage(with: "c"))
        XCTAssertEqual(viewModel.loadedMessages.count, 1)
        
        viewModel.loadMessages()
        
        XCTAssertEqual(viewModel.loadedMessages.count, 3)
    }
    
    func testCorretViewModelForCellIsCreated() {
        let message1 = createMessage(with: "a", owner: .interlocutor)
        viewModel.loadedMessages.append(message1)
        let message2 = createMessage(with: "b", owner: .user)
        viewModel.loadedMessages.append(message2)
        
        let cellVM = viewModel.getCellModel(for: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(cellVM.content, message1.content)
        XCTAssertEqual(cellVM.sender, message1.owner)
    }
    
    func testAddedMessageIsInsertedToLoadedMessages() {
        let firstMessageContent = "a"
        let secondMessageContent = "b"
        
        viewModel.addMessage(content: firstMessageContent, addingCharacterResponse: false)
        viewModel.addMessage(content: secondMessageContent, addingCharacterResponse: false)
        
        XCTAssertEqual(viewModel.loadedMessages[0].content, secondMessageContent)
        XCTAssertEqual(viewModel.loadedMessages[1].content, firstMessageContent)
    }
    
    func testMessagesAreAddedToRepositoryOnAdd() {
        viewModel.addMessage(content: "a")
        viewModel.addMessage(content: "b")
        
        XCTAssertEqual(messagesRepository.addCalledCounter, 2)
    }
    
    func testMessagesAddedDelegateCalledOnAdd() {
        viewModel.addMessage(content: "a")
        viewModel.addMessage(content: "b")
        
        XCTAssertEqual(delegateCalledCounter, 2)
    }
    
    func testMessageResponseIsAddedAfterDelayIfSet() {
        let responseExpectation = expectation(description: "response from marvel is added")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            if self?.viewModel.loadedMessages.count ?? 0 == 2 {
                responseExpectation.fulfill()
            }
        }
        
        viewModel.addMessage(content: "a", addingCharacterResponse: true)
        
        wait(for: [responseExpectation], timeout: 0.4)
    }
    
    private func createMessage(with content: String, owner: MessageOwner = .interlocutor) -> ChatMessage {
        return ChatMessage(owner: owner, content: content, timestamp: Date())
    }
}

extension CharacterChatViewModelTests: MessagesAddedDelegate {
    func messagesAdded(at indexes: [IndexPath]) {
        delegateCalledCounter += 1
    }
}

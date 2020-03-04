//
//  ChatMessageCellTests.swift
//  MarvelAppTestsV2
//
//  Created by Artur Stepaniuk on 28/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
import XCTest
import UIKit
@testable import MarvelApp

class ChatMessageCellTests: XCTestCase {
    
    var chatCell: ChatMessageCell!
    
    override func setUp() {
        chatCell = ChatMessageCell(frame: .zero)
    }
    
    func testCellIsConfiguredCorrectly() {
        let cellVM = ChatMessageCellViewModel(content: "a", sender: .user, ownerDisplayName: "k", date: Date())
        
        chatCell.configure(with: cellVM)
        
        XCTAssertEqual(chatCell.messageLabel.text, "a")
        XCTAssertEqual(chatCell.senderLabel.text, cellVM.senderInfo)
    }
    
    func testStackAlignmentIsSetCorrectlyBasedOnOwner() {
        let cellVM1 = ChatMessageCellViewModel(content: "a", sender: .user, ownerDisplayName: "a", date: Date())
        let cellVM2 = ChatMessageCellViewModel(content: "a", sender: .interlocutor, ownerDisplayName: "a", date: Date())
        
        chatCell.configure(with: cellVM1)
        XCTAssertEqual(chatCell.containerStack.alignment, .trailing)
        
        chatCell.configure(with: cellVM2)
        XCTAssertEqual(chatCell.containerStack.alignment, .leading)
        
    }
}

//
//  CharacterListViewModelTests.swift
//  MarvelAppTestsV2
//
//  Created by Artur Stepaniuk on 13/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import XCTest
import Foundation
@testable import MarvelApp

class CharacterListViewModelTests: XCTestCase {
    
    private var viewModel: CharacterListViewModel!
    private var characterProvider: MarvelCharacterProviderMock!
    private var avatarProvider: MarvelAvatarProvider!
    override func setUp() {
        characterProvider = MarvelCharacterProviderMock()
        avatarProvider = MarvelAvatarNetworkProvider()
        viewModel = CharacterListViewModel(characterProvider: characterProvider, avatarProvider: avatarProvider)
        characterProvider.resetCallingsCounter()
    }
    
    override func tearDown() {
        
    }
    
    func testTotalCharactersCountUpdatedAfterLoad() {
        
        XCTAssertEqual(viewModel.totalCharactersCount, 0)
        characterProvider.totalCharactersCount = 100
        
        viewModel.loadCharacters(at: firstUnloadedCharacterIndex()) { [weak self] result in
            switch result {
            case .success(_):
                XCTAssertEqual(self?.viewModel.totalCharactersCount, self?.characterProvider.totalCharactersCount)
            case .failure:
                return
            }
        }
    }
    
    func testCharactersArentLoadedWhenNoIndexesProvided() {
        viewModel.loadCharacters(at: [])
        XCTAssertEqual(characterProvider.callingsCounter, 0)
    }
    
    func testOnlyOneLoadingIsPerformedAtTime() {
        let firstLoadingExpectation = expectation(description: "first loading is started correctly")
        let secondLoadingExpectation = expectation(description: "second loading is not started")
        secondLoadingExpectation.isInverted = true
        viewModel.loadCharacters(at: firstUnloadedCharacterIndex()) { _ in
            firstLoadingExpectation.fulfill()
        }
        viewModel.loadCharacters(at: firstUnloadedCharacterIndex()) { _ in
            secondLoadingExpectation.fulfill()
        }
        
        wait(for: [firstLoadingExpectation, secondLoadingExpectation], timeout: 0.2)
    }
    
    func testGettingNextBatchUpdatesShownCharactersCount() {
        XCTAssertEqual(viewModel.shownCharactersCount, 0)
        viewModel.totalCharactersCount = viewModel.shownCharactersCount + viewModel.showBatchSize * 2
        
        let _ = viewModel.getNextCellsBatch()
        
        XCTAssertEqual(viewModel.shownCharactersCount, viewModel.showBatchSize)
    }
    
    func testShownCharactersCountDoesNotExceedTotalCountOnPresentingNextBatch() {
        XCTAssertEqual(viewModel.shownCharactersCount, 0)

        viewModel.totalCharactersCount = viewModel.showBatchSize - 1
        
        let _ = viewModel.getNextCellsBatch()
        
        XCTAssertEqual(viewModel.shownCharactersCount, viewModel.totalCharactersCount)
    }
    
    func testCantProvideMoreCharactersWhenAllShown() {
        viewModel.shownCharactersCount = 2
        viewModel.totalCharactersCount = 2
        
        XCTAssertFalse(viewModel.canProvideMoreCharacters())
    }
    
    func testReturnsNilForIncorrectCharacterIndexOnCellViewModelCreating() {
        XCTAssertEqual(viewModel.loadedCharacters.count, 0)
        
        XCTAssertNil(viewModel.getCellViewModel(at: 0))
    }
    
    func testReturnsCellViewModelWithCorrectData() {
        let character = createCharacter()
        viewModel.loadedCharacters.append(character)
        let characterViewModel = viewModel.getCellViewModel(at: 0)!
        
        XCTAssertEqual(characterViewModel.description, character.description)
        XCTAssertEqual(characterViewModel.imageURL, character.imageURL)
        XCTAssertEqual(characterViewModel.name, character.name)
    }
    
    private func createCharacter() -> MarvelCharacter {
        return MarvelCharacter(id: 0, name: "s", description: "s", imageURL: "")
    }
    
    private func firstUnloadedCharacterIndex() -> [Int] {
        return [viewModel.loadedCharacters.count + 1]
    }
}

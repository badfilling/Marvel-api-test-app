//
//  CharacterListViewModelImpl.swift
//  Marvel_test_example_app
//
//  Created by Artur Stepaniuk on 13/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

class CharacterListViewModel {
    
    let showBatchSize = 20
    
    var totalCharactersCount: Int = 0
    var shownCharactersCount = 0
    var loadedCharacters = [MarvelCharacter]()
    var onCharactersLoaded: ((_ indexes: [IndexPath]?) -> Void)?
    let characterProvider: MarvelCharacterProvider
    let avatarProvider: MarvelAvatarProvider
    let defaultIndexesToLoad: [Int]
    private var loadInProgress = false
    
    init(characterProvider: MarvelCharacterProvider, avatarProvider: MarvelAvatarProvider) {
        self.characterProvider = characterProvider
        self.avatarProvider = avatarProvider
        defaultIndexesToLoad = [characterProvider.defaultBatchSize]
    }
    
    func loadCharacters(at indices: [Int], _ completionHandler: ((Result<[MarvelCharacter],Error>) -> Void)? = nil) {
        guard let maxIndex = indices.max() else {
            return
        }
        guard maxIndex >= loadedCharacters.count else {
            return
        }
        guard !loadInProgress else {
            return
        }
        
        loadInProgress = true
        
        characterProvider.loadCharacters(having: loadedCharacters.count) { [weak self] result in
            guard let self = `self` else {
                return
            }
            
            self.loadInProgress = false

            switch result {
            case .success(let batch):
                let isFirstLoad = self.totalCharactersCount == 0
                self.totalCharactersCount = batch.totalCharactersCount
                
                if isFirstLoad {
                    self.shownCharactersCount = batch.totalCharactersCount > self.showBatchSize ? self.showBatchSize : batch.totalCharactersCount
                }
                
                let newIndexes = self.appendCalculatingIndexesToReload(characters: batch.characters)
                self.onCharactersLoaded?(isFirstLoad ? .none : newIndexes)
                completionHandler?(.success(batch.characters))
            case .failure(let error):
                self.onCharactersLoaded?([])
                completionHandler?(.failure(error))
            }
        }
    }
    
    private func appendCalculatingIndexesToReload(characters: [MarvelCharacter]) -> [IndexPath] {
        let indexes = calculateIndexesToReload(newBatchSize: characters.count)
        loadedCharacters.append(contentsOf: characters)
        return indexes
    }
    
    private func calculateIndexesToReload(newBatchSize: Int) -> [IndexPath] {
        return (loadedCharacters.count..<(loadedCharacters.count + newBatchSize)).map { IndexPath(row: $0, section: 0) }
    }
    
    func getNextCellsBatch() -> [IndexPath] {
        let oldCount = shownCharactersCount
        shownCharactersCount += showBatchSize
        shownCharactersCount = min(shownCharactersCount, totalCharactersCount)
        
        var newIndexes = [IndexPath]()
        for i in oldCount..<shownCharactersCount {
            newIndexes.append(IndexPath(row: i, section: 0))
        }
        return newIndexes
    }
    
    func canProvideMoreCharacters() -> Bool {
        return shownCharactersCount < totalCharactersCount
    }
    
    func getCellViewModel(at index: Int) -> MarvelCharacterCellViewModel? {
        guard index < loadedCharacters.count else {
            return nil
        }
        let character = loadedCharacters[index]
        return MarvelCharacterCellViewModel(name: character.name, description: character.description, imageURL: character.imageURL, imageProvider: avatarProvider)
    }
}

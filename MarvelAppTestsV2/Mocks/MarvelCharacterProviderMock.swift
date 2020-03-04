//
//  MarvelCharacterProviderMock.swift
//  MarvelAppTestsV2
//
//  Created by Artur Stepaniuk on 13/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
@testable import MarvelApp

class MarvelCharacterProviderMock: MarvelCharacterProvider {
    
    var characters = [MarvelCharacter]()
    var batch = MarvelCharacterBatch(totalCharactersCount: 0, characters: [])
    var totalCharactersCount = 1
    var callingsCounter = 0
    var delayBlock: (() -> Void)?
    func loadCharacters(having index: Int, _ completionHandler: @escaping ((Result<MarvelCharacterBatch, CharacterProviderError>) -> Void)) {
        callingsCounter += 1
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = `self` else {
                return
            }
            completionHandler(.success(MarvelCharacterBatch(totalCharactersCount: self.totalCharactersCount, characters: self.characters)))
        }
    }
    
    func resetCallingsCounter() {
        callingsCounter = 0
    }
    
}

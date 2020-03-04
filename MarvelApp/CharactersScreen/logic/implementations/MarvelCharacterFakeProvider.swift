//
//  MarvelCharacterFakeProvider.swift
//  MarvelApp
//
//  Created by Artur Stepaniuk on 21/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

class MarvelCharacterFakeProvider: MarvelCharacterProvider {
    
    func loadCharacters(having stored: Int, _ completionHandler: @escaping ((Result<MarvelCharacterBatch, CharacterProviderError>) -> Void)) {
        if let path = Bundle.main.url(forResource: "characters", withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                let objectDecoder = JSONDecoder()
                
                if let charactersContainer = try objectDecoder.decode(MarvelCharacterWrapperDto.self, from: data).data,
                    let totalCount = charactersContainer.total,
                    let charactersDtos = charactersContainer.results {
                    
                    let characters = charactersDtos.map { dto in
                        return MarvelCharacter(id: dto.id, name: dto.name, description: dto.description, imageURL: dto.thumbnail?.convertToURL() ?? "")
                    }
                    
                    let charactersBatch = MarvelCharacterBatch(totalCharactersCount: totalCount, characters: characters)

                    completionHandler(.success(charactersBatch))
                } else {
                    completionHandler(.failure(.unexpectedEmptyResponse))
                    return
                }
            } catch {
                completionHandler(.failure(.unexpectedEmptyResponse))
            }
        }
    }
    
    
}

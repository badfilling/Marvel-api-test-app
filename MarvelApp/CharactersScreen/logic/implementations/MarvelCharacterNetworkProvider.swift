//
//  MarvelCharacterNetworkProvider.swift
//  MarvelApp
//
//  Created by Artur Stepaniuk on 18/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

class MarvelCharacterNetworkProvider: MarvelCharacterProvider {
    
    private let maxBatchSize = 40
    private let characterEndpoint: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "gateway.marvel.com"
        components.path = "/v1/public/characters"
        
        components.queryItems = [
            URLQueryItem(name: "apikey", value: AppSecrets.marvelApiKey),
            URLQueryItem(name: "ts", value: "mytimestamp"),
            URLQueryItem(name: "hash", value: "7279e3f3faedb0393db2a40ef923ccec")
        ]
        
        return components
    }()
    
    func loadCharacters(having stored: Int, _ completionHandler: @escaping ((Result<MarvelCharacterBatch, CharacterProviderError>) -> Void)) {
        
        var urlComponents = characterEndpoint
        urlComponents.queryItems?.append(contentsOf: [
            URLQueryItem(name: "offset", value: "\(stored)"),
            URLQueryItem(name: "limit", value: "\(maxBatchSize)")
        ])
        
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { data, _, error in
            if let error = error {
                completionHandler(.failure(.network(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.unexpectedEmptyResponse))
                return
            }
            
            do {
                let objectDecoder = JSONDecoder()
                if let charactersContainer = try objectDecoder.decode(MarvelCharacterWrapperDto.self, from: data).data,
                    let totalCount = charactersContainer.total,
                    let charactersDtos = charactersContainer.results {
                    
                    let characters = charactersDtos.map { dto in
                        return MarvelCharacter(id: dto.id, name: dto.name, description: dto.description, imageURL: dto.thumbnail?.convertToURL() ?? "")
                    }
                    
                    let charactersBatch = MarvelCharacterBatch(totalCharactersCount: totalCount, characters: characters)
                    print("loaded \(characters.count) characters, offset: \(stored), specified batchSize: \(self.maxBatchSize)")
                    completionHandler(.success(charactersBatch))
                } else {
                    completionHandler(.failure(.unexpectedEmptyResponse))
                    return
                }
            }
            catch {
                completionHandler(.failure(.decodingError))
            }
        }
        task.resume()
    }
}

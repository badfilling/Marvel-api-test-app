//
//  CharacterProvider.swift
//  Marvel_test_example_app
//
//  Created by Artur Stepaniuk on 13/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

protocol MarvelCharacterProvider {
    func loadCharacters(having stored: Int, _ completionHandler: @escaping ((Result<MarvelCharacterBatch, CharacterProviderError>) -> Void))
    var defaultBatchSize: Int { get }
}

enum CharacterProviderError: Error {
    case network(_ errorDescription: String)
    case unexpectedEmptyResponse
    case decodingError
}

extension MarvelCharacterProvider {
    var defaultBatchSize: Int { return 100 }
}

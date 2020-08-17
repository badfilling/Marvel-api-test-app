//
//  MarvelAvatarNetworkProvider.swift
//  MarvelApp
//
//  Created by Artur Stepaniuk on 18/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

class MarvelAvatarNetworkProvider: MarvelAvatarProvider {
    
    func setImage(for url: String, in view: UIImageView) -> CancelLoadingHandler? {
        guard let imageURL = URL(string: url) else {
            return nil
        }
        
        let request = URLRequest(url: imageURL)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let response = response, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    view.image = image
                }
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = URLCache.shared.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    view.image = image
                }
                task.cancel()
            } else {
                task.resume()
            }
        }
        
        return {
            if task.state == .running {
                task.cancel()
            }
        }
    }
}

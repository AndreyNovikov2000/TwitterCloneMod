//
//  WebImageView.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/12/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class WebImageView: UIImageView {
    private var currentImageUrl: URL?
    
    func set(imageUrl: URL?) {
        guard let url = imageUrl else {
            self.image = nil
            return
        }
        currentImageUrl = url
        
        if let cacheResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cacheResponse.data)
            return
        }
        
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("DEBUG: Error - \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let response = response else { return }
            DispatchQueue.main.async {
                self.handleLoadedImage(with: data, response: response)
            }
        }
        
        dataTask.resume()
    }
    
    private func handleLoadedImage(with data: Data, response: URLResponse) {
        guard let url = response.url else { return }
        let request = URLRequest(url: url)
        let urlresponse = CachedURLResponse(response: response, data: data)
        
        URLCache.shared.storeCachedResponse(urlresponse, for: request)
        
        if response.url == currentImageUrl {
            self.image = UIImage(data: data)
        }
    }
}

//
//  SimpleImageCache.swift
//  TheMovieDBDemo
//
//  Created by Khanh Vo on 27/10/2023.
//

import UIKit

typealias COMPLETION = (UIImage?, Error?) -> Void

class SimpleImageCache {
    static let shared = SimpleImageCache()
    
    let session = URLSession(configuration: .ephemeral)
    var loadingResponses: [URL: [COMPLETION]] = [:]
//    var cachedImages = NSCache<NSURL, UIImage>()
    
    func loadImage(_ urlString: String?, completion: @escaping COMPLETION) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        
        // Add completion to loading responses
        var items = loadingResponses[url] ?? []
        items.append(completion)
        loadingResponses[url] = items
        
        let urlRequest = URLRequest(url: url)
        
        // Try to return cached image first
//        if let key = NSURL(string: url.absoluteString), let image = cachedImages.object(forKey: key) {
//            loadingResponses[url]?.forEach({ completion in
//                completion(image, nil)
//            })
//            loadingResponses.removeValue(forKey: url)
//            return
//        }
        if let cache = session.configuration.urlCache?.cachedResponse(for: urlRequest) {
            let image = UIImage(data: cache.data)
            loadingResponses[url]?.forEach({ completion in
                completion(image, nil)
            })
            loadingResponses.removeValue(forKey: url)
            return
        }
        
        // Fetch origin image
        session.dataTask(with: urlRequest, cacheResponse: false) { [weak self] data, response, error in
            guard let weakSelf = self else { return }
            
            guard let data = data, let response = response else {
                weakSelf.loadingResponses[url]?.forEach({ completion in
                    completion(nil, error)
                })
                weakSelf.loadingResponses.removeValue(forKey: url)
                return
            }
                        
            let image = UIImage(data: data)
            
//            if image != nil, let key = NSURL(string: url.absoluteString) {
//                weakSelf.cachedImages.setObject(
//                    image!,
//                    forKey: key,
//                    cost: data.count
//                )
//            }
            if image != nil {
                weakSelf.session.configuration.urlCache?.storeCachedResponse(
                    CachedURLResponse(
                        response: response,
                        data: data
                    ),
                    for: urlRequest
                )
            }
            
            weakSelf.loadingResponses[url]?.forEach({ completion in
                completion(image, nil)
            })
            weakSelf.loadingResponses.removeValue(forKey: url)
        }.resume()
    }
}

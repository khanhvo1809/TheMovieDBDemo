//
//  URLSession+Ext.swift
//  TheMovieDBDemo
//
//  Created by Khanh Vo on 27/10/2023.
//

import Foundation

extension URLSession {
    func dataTask(
        with urlRequest: URLRequest,
        cacheResponse: Bool,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            return self.dataTask(with: urlRequest) { (data, response, error) in
                if cacheResponse, let response = response, let data = data {
                    self.configuration.urlCache?.storeCachedResponse(
                        CachedURLResponse(
                            response: response,
                            data: data,
                            storagePolicy: .allowed
                        ),
                        for: urlRequest
                    )
                }
                completion(data, response, error)
            }
        }
    
}

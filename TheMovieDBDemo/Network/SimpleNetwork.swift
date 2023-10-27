//
//  SimpleNetwork.swift
//  TheMovieDBDemo
//
//  Created by Khanh Vo on 27/10/2023.
//

import Foundation
import Network

class SimpleNetworkDetection {
    static let shared = SimpleNetworkDetection()
    
    let monitor = NWPathMonitor()
    var connectionStatus = false
    
    func startMonitor() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.connectionStatus = true
                print("We're connected!")
            } else {
                self.connectionStatus = false
                print("No connection.")
            }
            
            NotificationCenter.default.post(
                Notification(
                    name: Notification.Name("networkChanged")
                )
            )
        }
        
        let queue = DispatchQueue(label: "vn.kvnvo.NetworkMonitor")
        monitor.start(queue: queue)
    }
}

struct SimpleNetwork {
    static let shared = SimpleNetwork()

    private static let baseQueryParams = [
        "api_key": Constants.API_KEY,
        "language": "en-US"
    ]
    private static let baseHeaders = [
        "accept": "application/json"
    ]
    
    static func get<T: Codable>(
        _ urlString: String,
        queryParams: [String: String]? = nil,
        headers: [String: String]? = nil,
        cacheResponse: Bool = false,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let allQueryParams = baseQueryParams.merging(queryParams ?? [:]) { $1 }
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = allQueryParams.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        guard let url = urlComponents?.url else {
            completion(.failure(NSError(domain: "vn.kvnvo.SimpleNetwork", code: -1)))
            return
        }
        
        let allHeaders = baseHeaders.merging(headers ?? [:]) { $1 }
        let request = NSMutableURLRequest(
            url: url,
            cachePolicy: .reloadRevalidatingCacheData,
            timeoutInterval: 3.0
        )
        allHeaders.forEach { (key, value) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let session = URLSession.shared
        
        print("__DEBUG__:: \(request.url?.absoluteString)")
        if let cache = session.configuration.urlCache?.cachedResponse(for: request as URLRequest) {
            print("__DEBUG__ load cache:: \(request.url?.absoluteString)")
            
            if let dataObj = try? JSONDecoder().decode(T.self, from: cache.data) {
                completion(.success(dataObj))
                return
            }
        }
        
        let dataTask = session.dataTask(
            with: request as URLRequest,
            cacheResponse: cacheResponse
        ) { data, response, error in
            if let _ = data, let dataObj = try? JSONDecoder().decode(T.self, from: data!) {
                completion(.success(dataObj))
            } else {
                completion(.failure(error ?? NSError(domain: "vn.kvnvo.SimpleNetwork", code: -2)))
            }
        }
        
        dataTask.resume()
    }
}

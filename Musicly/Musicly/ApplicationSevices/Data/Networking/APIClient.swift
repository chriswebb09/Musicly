//
//  APIClient.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/9/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

// MARK: - JSON type

typealias JSON = [String: Any]

@objc(iTunesAPIClient)
final class iTunesAPIClient: NSObject {
    
    // JSON completion typealiases for asynchronous code
    
    typealias jsonCompletion = (_ responseObject: JSON?, _ error: Error?) -> Void
    
    // MARK: - Main search functionality
    
    static func search(for query: String, completion: @escaping jsonCompletion) {
        if let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=\(encodedQuery)") {
            self.downloadData(url: url) { data, response, error in
                if let error = error {
                    completion(nil, error)
                } else {
                    do {
                        let responseObject = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                        DispatchQueue.main.async {
                            completion(responseObject, nil)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // MARK: - Transitory session
    
    internal static func downloadData(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        weak var downloadSession : URLSession? {
            get {
                let config = URLSessionConfiguration.ephemeral
                return URLSession(configuration: config)
            }
        }
        
        let task: URLSessionDataTask? = downloadSession?.dataTask(with: URLRequest(url: url)) { data, response, error in
            completion(data, response, error)
            downloadSession?.invalidateAndCancel()
        }
        
        task?.resume()
        
    }
}



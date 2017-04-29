//
//  APIClient.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/9/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class iTunesAPIClient {
    
    // MARK: - Main search functionality
    
    static func search(for query: String, completion: @escaping (_ responseObject: [String: Any]?, _ error: Error?) -> Void) {
        if let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=\(encodedQuery)") {
            URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
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
                }.resume()
        }
    }
}

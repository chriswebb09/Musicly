//
//  APIClient.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/9/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

enum URLRouter {
    
    case base, path
    
    var url: String {
        switch self {
        case .base:
            return "https://itunes.apple.com"
        case .path:
            return "/search?media=music&entity=song&term="
        }
    }
    
}

final class iTunesAPIClient {
    
    // MARK: - Main search functionality
    
    static func search(for query: String, completion: @escaping (_ responseObject: [String: Any]?, _ error: Error?) -> Void) {
        if let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL(string: "\(URLRouter.base.url)\(URLRouter.path.url)\(encodedQuery)") {
            print(url.absoluteURL)
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

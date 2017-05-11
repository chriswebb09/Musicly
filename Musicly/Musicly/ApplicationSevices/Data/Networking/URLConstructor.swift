//
//  URLConstructor.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/1/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

struct URLConstructor {
    
    var searchTerm: String
    
    func build(searchTerm: String) -> URL? {
        let encodedQuery = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlString = URLRouter.base.url + URLRouter.path.url + encodedQuery
        return URL(string: urlString)
    }
}

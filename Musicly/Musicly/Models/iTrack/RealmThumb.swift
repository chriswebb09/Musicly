//
//  RealmThumb.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/23/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

enum Thumbs {
    case up, down, none
}

class RealmThumb: Object {
    
    var thumb: Thumbs
    
    convenience init(thumb: Thumbs) {
        self.init()
        self.thumb = thumb
    }
    
    required init() {
        self.thumb = .none
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        self.thumb = .none
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        self.thumb = .none
        super.init(value: value, schema: schema)
    }
}

//
//  RealmDatabase+Extension.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/24/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Realm
import RealmSwift

extension Realm {
    func save(entityList: [TrackList], shouldUpdate update: Bool = true) {
        let database = try! Realm()
        database.beginWrite()
        for entity in entityList {
            if let key = type(of: entity).primaryKey(), let value = entity[key] , update {
                if let existingObject = database.object(ofType: type(of: entity), forPrimaryKey: value as AnyObject) {
                    let relationships = existingObject.objectSchema.properties.filter {
                        $0.type == .array
                    }
                    for relationship in relationships {
                        if let newObjectRelationship = entity[relationship.name] as? ListBase , newObjectRelationship.count == 0 {
                            entity[relationship.name] = existingObject[relationship.name]
                        }
                    }
                }
            }
            database.add(entity, update: update)
        }
        
        do {
            try database.commitWrite()
        } catch let writeError {
            debugPrint("Unable to commit write: \(writeError)")
        }
        
        database.refresh()
    }
    
    func newSave(list: TrackList) {
        try! self.write {
            self.add(list, update: true)
        }
    }
}

import Foundation
import RealmSwift
import Realm

final class RealmThumb: Object {
    
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

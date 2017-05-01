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

struct URLConstructor {
    
    var searchTerm: String
    
    func build() -> URL {
        let encodedQuery = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlString = URLRouter.base.url + URLRouter.path.url + encodedQuery
        return URL(string: urlString)!
    }
}

final class iTunesAPIClient {
    
    // MARK: - Main search functionality
    
    static func search(for query: String, completion: @escaping (_ responseObject: [String: Any]?, _ error: Error?) -> Void) {
        let urlConstructor = URLConstructor(searchTerm: query)
        
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: urlConstructor.build())) { data, response, error in
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

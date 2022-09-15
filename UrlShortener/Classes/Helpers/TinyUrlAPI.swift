//
//  TinyUrlAPI.swift
//  UrlShortener
//
//  Created by David Ansermot on 19.04.22.
//

import Foundation

/// Represent a TinyUrl API error
///
/// - Author: David Ansermot
/// - Date: 2022.04.20
///
/// - Require:
///   - `Error`
///
enum TinyUrlAPIError: Error {
    case invalidUrl
    case noUrlAvailable
    case unknownServerError
}


// MARK -
/// Represent a TinyUrl API error
///
/// - Author: David Ansermot
/// - Date: 2022.04.20
///
/// - Require:
///   - `Error`
///
class TinyUrlAPI {
    
    /// Singleton
    static let shared = TinyUrlAPI()
    /// API base url
    var baseUrl: String { return "https://tinyurl.com/api-create.php?url=" }
    
    
    
    // --------------------------------------------------------
    // MARK: - Object lifecycle
    
    /// Default initializer
    ///
    private init() { }
    
    
    
    // --------------------------------------------------------
    // MARK: - API commands
    
    
    /// Create a short url from a long url **string** using TinyURL public API
    ///
    /// - Author: David Ansermot
    /// - Date: 2022.04.19
    ///
    /// - Parameter longUrlString: The long url to shorten as `String`
    /// - Parameter completion: Completion closure called when work done
    /// - Returns: `Void`
    ///
    func create(longUrlString: String,  completion: @escaping (String?, TinyUrlAPIError?) -> Void) {
        let finalUrl = "\(self.baseUrl)\(longUrlString)"
        if let url = URL(string: finalUrl) {
            self.create(longUrl: url, completion: completion)
            return
        }
        completion(nil, TinyUrlAPIError.invalidUrl)
    }
    
    /// Create a short url from a long url using TinyURL public API
    ///
    /// - Author: David Ansermot
    /// - Date: 2022.04.19
    ///
    /// - Important: The api call is made in **global queue**
    ///
    /// - Parameter longUrl: The long url to shorten
    /// - Parameter completion: Completion closure called when work done
    /// - Returns: `Void`
    ///
    func create(longUrl: URL, completion: @escaping (String?, TinyUrlAPIError?) -> Void) {
        DispatchQueue.global().async {
            do {
                let string = try String(contentsOf: longUrl, encoding: .utf8)
                completion(string, nil)
            } catch {
                if let tinyError = error as? TinyUrlAPIError {
                    completion(nil, tinyError)
                } else {
                    completion(nil, .unknownServerError)
                }
            }
        }
    }
    
}

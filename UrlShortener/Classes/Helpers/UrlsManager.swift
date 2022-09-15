//
//  UrlsManager.swift
//  UrlShortener
//
//  Created by David Ansermot on 19.04.22.
//

import Foundation

/// Represent a TinyUrl object
///
/// - Author: David Ansermot
/// - Date: 2022.04.19
///
/// - Require:
///   - `Codable`
///
struct TinyUrl: Codable {
    /// Long url
    var long: String
    /// Short url
    var short: String
    /// Date of shortening
    var date: Date
}


// MARK: -
/// Manage the urls
///
///
/// - Author: David Ansermot
/// - Date: 2022.04.19
///
class UrlsManager {
    
    /// Singleton instance
    static let main = UrlsManager(identifier: UrlsManager.mainIdentifier)
    /// Main identifier for the manager
    static let mainIdentifier = "shortenedUrls"
    
    /// List of urls shortened
    open var urlsList: [TinyUrl]
    /// Number of urls shortened
    open var count: Int { return self.urlsList.count }
    /// Identifier for settings/manager
    open var identifier: String
    
    
    
    // --------------------------------------------------------
    // MARK: - Object lifecycle
    
    /// Default initializer
    ///
    /// Loads the urls list from settings
    ///
    public init(identifier: String) {
        self.identifier = identifier
        self.urlsList = [TinyUrl]()
        self.load()
    }
    
    
    
    // --------------------------------------------------------
    // MARK: - Urls Management
    
    /// Gets an url at a position
    ///
    /// - Author: David Ansermot
    /// - Date: 2022.04.19
    ///
    /// - Parameter index: Index of the url to get
    /// - Returns: `TinyUrl?`
    ///
    func get(for index: Int) -> TinyUrl? {
        guard index < self.urlsList.count else { return nil }
        return self.urlsList[index]
    }
    
    /// Save an url
    ///
    /// - Author: David Ansermot
    /// - Date: 2022.04.19
    ///
    /// - Parameter url: The url to save
    /// - Returns: `Void`
    ///
    func add(_ url: TinyUrl) {
        self.urlsList.insert(url, at: 0)
        self.save()
    }
    
    /// Flush all saved urls
    ///
    /// - Author: David Ansermot
    /// - Date: 2022.04.19
    ///
    /// - Returns: `Void`
    ///
    func flush() {
        self.urlsList.removeAll()
        self.save()
    }
    
    /// Loads the urls from the settings
    ///
    /// - Author: David Ansermot
    /// - Date: 2022.04.19
    ///
    /// - Important: `@discardableResult`, `open`
    ///
    /// - Returns: `Bool`
    ///
    @discardableResult open func load() -> Bool {
        if let data = UserDefaults.standard.data(forKey: self.identifier) {
            if let array = try? PropertyListDecoder().decode([TinyUrl].self, from: data) {
                self.urlsList = array
                return true
            }
        }
        return false
    }
    
    /// Saves the urls to the settings
    ///
    /// - Author: David Ansermot
    /// - Date: 2022.04.19
    ///
    /// - Important: `open`, `@discardableResult`
    ///
    /// - Returns: `Bool`
    ///
    @discardableResult open func save() -> Bool {
        if let data = try? PropertyListEncoder().encode(self.urlsList) {
            UserDefaults.standard.set(data, forKey: self.identifier)
            return true
        }
        return false
    }
}

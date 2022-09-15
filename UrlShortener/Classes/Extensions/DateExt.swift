//
//  DateExt.swift
//  UrlShortener
//
//  Created by David Ansermot on 20.04.22.
//

import Foundation

extension Date {
    
    /// Returns the date as String formatted
    ///
    /// - Author: David Ansemrot
    /// - Date: 2022.04.20
    ///
    /// - Parameter format: The format to use for the date
    /// - Returns: `String`
    ///
    func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}

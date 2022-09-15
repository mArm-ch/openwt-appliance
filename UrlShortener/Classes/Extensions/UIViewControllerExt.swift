//
//  UIViewControllerExt.swift
//  UrlShortener
//
//  Created by David Ansermot on 20.04.22.
//

import UIKit

extension UIViewController {
    
    /// Display a basic alert view with message, optional title and an ok button
    ///
    /// - Author: David Ansemrot
    /// - Date: 2022.04.20
    ///
    /// - Parameter message: Message to display
    /// - Parameter title: Optional title
    /// - Returns: `Void`
    ///
    func showAlert(_ message: String, title: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

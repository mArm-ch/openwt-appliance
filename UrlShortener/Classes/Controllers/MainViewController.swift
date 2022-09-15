//
//  MainViewController.swift
//  UrlShortener
//
//  Created by David Ansermot on 19.04.22.
//

import UIKit

/// Represent a TinyUrl object
///
/// - Author: David Ansermot
/// - Date: 2022.04.19
///
/// - Require:
///   - `UIViewController`
///
class MainViewController: UIViewController {
    
    @IBOutlet var urlTextfield: UITextField!
    @IBOutlet var shortenButton: UIButton!
    @IBOutlet var eraseButton: UIButton!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var urlsTableView: UITableView!
    
    /// Cell identifier for urls tableView
    static var urlCellID: String { return "urlCellID" }
   
    
    
    // --------------------------------------------------------
    // MARK: - View Lifecycle
    
    /// View has been loaded
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.indicator.hidesWhenStopped = true
        
        self.urlsTableView.delegate = self
        self.urlsTableView.dataSource = self
        self.urlsTableView.backgroundColor = .white
        
        self.shortenButton.layer.cornerRadius = 4.0
        self.eraseButton.layer.cornerRadius = 4.0
    }
    
    
    
    // --------------------------------------------------------
    // MARK: - UI Events
    
    /// Shorten an url
    ///
    /// - Author: David Ansermot
    /// - Date: 2022.04.20
    ///
    /// - Important: `@IBAction`
    ///
    /// - Parameter sender: The UI sender element
    /// - Returns: `Void`
    ///
    @IBAction func shortenUrl(sender: Any?) {
        
        guard let longUrlText = self.urlTextfield.text,
                longUrlText != "" else { return }
        
        // Update UI
        self.indicator.startAnimating()
        self.shortenButton.setTitle("", for: .normal)
        self.urlTextfield.resignFirstResponder()
        
        // Creates the short url in background
        TinyUrlAPI.shared.create(longUrlString: longUrlText) { shortUrl, error in
            
            if let error = error {
                
                // Display error to user
                DispatchQueue.main.async {
                    self.showAlert(error.localizedDescription, title: "Error")
                }
                
            } else {
                
                // Save short url and update tableView
                DispatchQueue.main.async {
                    if let shortUrl = shortUrl {
                        UrlsManager.main.add(TinyUrl(long: longUrlText,
                                                     short: shortUrl,
                                                     date: Date()))
                        self.urlsTableView.reloadData()
                    } else {
                        self.showAlert("No short url available", title: "Error")
                    }
                }
            }
            
            // Update UI
            DispatchQueue.main.async {
                self.urlTextfield.text = ""
                self.shortenButton.setTitle("Shorten", for: .normal)
                self.indicator.stopAnimating()
            }
        }
    }
    
    /// Erase all saved urls
    ///
    /// - Author: David Ansermot
    /// - Date: 2022.04.20
    ///
    /// - Important: `@IBAction`
    ///
    /// - Parameter sender: The UI sender element
    /// - Returns: `Void`
    ///
    @IBAction func eraseUrls(sender: Any?) {
        let alert = UIAlertController(title: "Erase all",
                                      message: "This action will erase all urls, and is irreversible.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            UrlsManager.main.flush()
            self.urlsTableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}



// --------------------------------------------------------
// MARK: - Ext: UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    /// Open the original url in browser
    ///
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let urlItem = UrlsManager.main.get(for: indexPath.row),
              let urlToOpen = URL(string: urlItem.long) else { return }
        
        if UIApplication.shared.canOpenURL(urlToOpen) {
            UIApplication.shared.open(urlToOpen, options: [:], completionHandler: nil)
        } else {
            self.showAlert("Unable to open long url in browser", title: "Error")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}



// --------------------------------------------------------
// MARK: - Ext: UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    /// numberOfRowsInSection
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UrlsManager.main.count
    }
    
    /// cellForRowAt
    ///
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Gets a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: MainViewController.urlCellID, for: indexPath)
        
        // Default cell if no url for index (should not happends)
        guard let urlItem = UrlsManager.main.get(for: indexPath.row) else {
            cell.contentConfiguration = self.configureCell(cell, text: "???", secondaryText: "???")
            return cell
        }
        
        // Prepare title line string
        let topLineString = NSMutableAttributedString(string: "(\(urlItem.date.toString())) \(urlItem.short)")
        let rangeDate = NSRange(location: 0, length: urlItem.date.toString().count + 2)
        topLineString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11.0, weight: .light)], range: rangeDate)
        let rangeLink = NSRange(location: urlItem.date.toString().count + 3, length: urlItem.short.count)
        topLineString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0, weight: .bold)], range: rangeLink)
        
        // Cell content configuration for display
        cell.contentConfiguration = self.configureCell(cell, attributedText: topLineString, secondaryText: urlItem.long)
        
        return cell
    }
    
    /// Configure a cell with a first and second line
    ///
    /// - Author: David Ansermot
    /// - Date: 2022.04.20
    ///
    /// - Important: `fileprivate`
    ///
    /// - Parameter cell: The cell to configure
    /// - Parameter text: A normal text for topline (default: `""`
    /// - Parameter attributedText: An optional attributed text that replace the "text" parameter value
    /// - Parameter secondaryText: The bottom line text (default: `""`
    /// - Returns: `Void`
    ///
    fileprivate func configureCell(_ cell: UITableViewCell, text: String = "", attributedText: NSAttributedString? = nil, secondaryText: String = "") -> UIListContentConfiguration {
        var contentConfiguration = cell.defaultContentConfiguration()
        
        // Attributed text take precedence on text
        if let attributed = attributedText {
            contentConfiguration.attributedText = attributed
        } else {
            contentConfiguration.text = text
        }
        contentConfiguration.secondaryText = secondaryText
        return contentConfiguration
    }
}

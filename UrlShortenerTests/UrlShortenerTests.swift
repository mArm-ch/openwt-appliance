//
//  UrlShortenerTests.swift
//  UrlShortenerTests
//
//  Created by David Ansermot on 19.04.22.
//

import XCTest
@testable import UrlShortener

class UrlShortenerTests: XCTestCase {
    
    let manager = UrlsManager(identifier: "testManager")

    override func setUpWithError() throws {
        self.manager.flush()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_Add() throws {
            
        let date = Date()
        let url = TinyUrl(long: "aaa", short: "bbb", date: date)
        
        self.manager.add(url)
        
        XCTAssertTrue(self.manager.urlsList.count == 1, "Number of urls in urlsList should be 1")
        
        let addedUrl = self.manager.urlsList[0]
        XCTAssertTrue(url.short == addedUrl.short, "Short url is different from reference")
        XCTAssertTrue(url.long == addedUrl.long, "Long url is different from reference")
        XCTAssertTrue(url.date == addedUrl.date, "Date is different from reference")
    }

    func test_Get() throws {
        let date = Date()
        let url = TinyUrl(long: "aaa", short: "bbb", date: date)
        
        self.manager.urlsList.insert(url, at: 0)
        
        let addedUrl = self.manager.get(for: 0)
        XCTAssertNotNil(addedUrl, "Url for position 0 is nil, should not.")
        
        if let addedUrl = addedUrl {
            XCTAssertTrue(url.short == addedUrl.short, "Short url is different from reference")
            XCTAssertTrue(url.long == addedUrl.long, "Long url is different from reference")
            XCTAssertTrue(url.date == addedUrl.date, "Date is different from reference")
        }
    }

}

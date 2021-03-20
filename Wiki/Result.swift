//
//  Result.swift
//  Wiki
//
//  Created by Lukas Zelenay on 19/03/2021.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable {
    let pageid: Int?
    let title, snippet: String?
    let fullurl: String?
}


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
    let title: String?
    //plati pre dopyt na api s parametrami prop=extracts&exintro&explaintext
//    let extract: String?
    
    //pri dopyte na prop=info plati:
    let snippet: String?
    let fullurl: String?
}


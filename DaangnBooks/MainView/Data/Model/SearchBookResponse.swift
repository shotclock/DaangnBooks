//
//  SearchBookResponse.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/13/24.
//

import Foundation

struct SearchBookResponse: Decodable {
    let total: String
    let books: [SearchBookInfo]
}

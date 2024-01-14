//
//  SearchBookResult.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/13/24.
//

import Foundation

struct SearchBookResult: Decodable {
    let total: String
    let books: [SearchBookInfo]
}

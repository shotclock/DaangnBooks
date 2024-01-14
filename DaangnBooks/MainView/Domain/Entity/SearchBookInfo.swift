//
//  SearchBookInfo.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/13/24.
//

import Foundation

struct SearchBookInfo: Decodable, Equatable {
    let title: String
    let subtitle: String
    let isbn13: String
    let image: String
    let url: String
}

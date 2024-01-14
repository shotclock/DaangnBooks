//
//  BookDetailResponse.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/15/24.
//

import Foundation

struct BookDetailResponse: Decodable {
    let error: String
    let title: String
    let subtitle: String
    let authors: String
    let publisher: String
    let isbn10: String
    let isbn13: String
    let pages: String
    let year: String
    let rating: String
    let desc: String
    let price: String
    let image: String
    let url: String
    let pdf: [String: String]?
    
    func toDomain() -> DetailBookInfo {
        .init(title: title,
              subTitle: subtitle,
              authors: authors,
              isbn10: isbn10,
              isbn13: isbn13,
              pages: pages,
              year: year,
              rating: rating,
              description: desc,
              imageURL: image,
              webPageURL: url,
              pdf: pdf)
    }
}

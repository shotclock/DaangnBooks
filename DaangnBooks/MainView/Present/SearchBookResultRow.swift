//
//  SearchBookResultRow.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/14/24.
//

import SwiftUI

struct SearchBookResultRow: View {
    private let model: BookSearchInfo
    
    init(model: BookSearchInfo) {
        self.model = model
    }
    
    var body: some View {
        HStack {
            imageArea
            descriptionArea
            Spacer()
            trailingArea
        }
    }
    
    var imageArea: some View {
        AsyncImage(url: .init(string: model.image)) { phase in
            phase
                .image?
                .resizable()
        }
        .frame(height: 100)
        .aspectRatio(9 / 16, contentMode: .fit)
        .cornerRadius(5)
    }
    
    var descriptionArea: some View {
        VStack(alignment: .leading,
               spacing: 10) {
            Text(model.title)
                .font(.system(size: 15,
                              weight: .bold))
            Text(model.subtitle)
                .font(.system(size: 10))
            Text(model.isbn13)
                .font(.system(size: 7))
                .foregroundColor(.blue)
        }
    }
    
    @ViewBuilder
    var trailingArea: some View {
        if let url = URL(string: model.url) {
            VStack {
                Spacer()
                Link(destination: url,
                     label: {
                    Text("링크")
                })
            }
        }
    }
}

#Preview {
    SearchBookResultRow(model: .init(title: "테스트",
                                     subtitle: "subtitle 테스트",
                                     isbn13: "isbn",
                                     image: "",
                                     url: ""))
}

//
//  BookDetailView.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/14/24.
//

import SwiftUI

struct BookDetailView: View {
    private let isbn13: String
    @State private var viewModel: BookDetailViewModel
    
    init(isbn13: String,
         viewModel: BookDetailViewModel) {
        self.isbn13 = isbn13
        _viewModel = .init(initialValue: viewModel)
    }
    
    var body: some View {
        if let detailInfo = viewModel.detailInfo {
            VStack {
                topArea(bookInfo: detailInfo)
                descriptionArea(bookInfo: detailInfo)
            }
        } else {
            LoadingView()
                .onAppear {
                    if viewModel.detailInfo == nil {
                        viewModel.fetchDetailInfo(isbn13: isbn13)
                    }
                }
        }
    }
    
    private func topArea(bookInfo: DetailBookInfo) -> some View {
        HStack {
            if let url = URL(string: bookInfo.imageURL) {
                CachedAsyncImage(url: url)
            }
            Spacer()
            VStack {
                Text(bookInfo.title)
                    .font(.system(size: 15,
                                  weight: .bold))
                Text(bookInfo.subTitle)
                    .font(.system(size: 10))
                Text(bookInfo.authors)
                    .font(.system(size: 10))
                Spacer()
                VStack(alignment: .trailing) {
                    Text(bookInfo.isbn10)
                        .font(.system(size: 7))
                        .foregroundColor(.blue)
                    Text(bookInfo.isbn13)
                        .font(.system(size: 7))
                        .foregroundColor(.blue)
                }
            }
        }
    }
    
    private func descriptionArea(bookInfo: DetailBookInfo) -> some View {
        VStack {
            Text(bookInfo.description)
        }
    }
}

#Preview {
    BookDetailView(isbn13: "", 
                   viewModel: DetailViewDependencyContainer().resolveBookDetailViewModel())
}

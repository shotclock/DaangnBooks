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
            VStack(alignment: .trailing, 
                   spacing: 20) {
                infoArea(bookInfo: detailInfo)
                descriptionArea(bookInfo: detailInfo)
                linkArea(bookInfo: detailInfo)
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
    
    private func infoArea(bookInfo: DetailBookInfo) -> some View {
        HStack {
            VStack(spacing: 10) {
                if let url = URL(string: bookInfo.imageURL) {
                    CachedAsyncImage(url: url)
                        .frame(width: 100,
                               height: 150)
                        .aspectRatio(contentMode: .fill)
                        .background(Color.gray)
                        .cornerRadius(5)
                }
                Text(bookInfo.price)
                    .font(.system(size: 15, 
                                  weight: .bold))
            }
            
            Spacer()
            VStack(alignment: .leading) {
                Text(bookInfo.title)
                    .font(.system(size: 20,
                                  weight: .bold))
                Text(bookInfo.subTitle)
                    .font(.system(size: 15))
                Text("\(bookInfo.pages) pages")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                Text(bookInfo.authors)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                Text(bookInfo.year)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                HStack {
                    ForEach(0..<Int(bookInfo.rating), id: \.self) { _ in
                        Image(systemName: Images.Strings.star)
                            .resizable()
                            .frame(width: 10, 
                                   height: 10)
                            .foregroundColor(.yellow)
                    }
                }
                Spacer()
                    .frame(height: 15)
                Group {
                    Text("isbn10 : \(bookInfo.isbn10)")
                    Text("isbn13 : \(bookInfo.isbn13)")
                }
                .font(.system(size: 10))
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity,
                       alignment: .trailing)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func descriptionArea(bookInfo: DetailBookInfo) -> some View {
        VStack {
            Text(bookInfo.description)
        }
    }
    
    private func linkArea(bookInfo: DetailBookInfo) -> some View {
        VStack {
            if let url = URL(string: bookInfo.webPageURL) {
                Link(destination: url,
                     label: {
                    Text("외부 링크")
                        .frame(maxWidth: .infinity,
                               alignment: .trailing)
                })
            }
            
            if let pdf = bookInfo.pdf {
                HStack {
                    Text("Sample: ")
                    let sortedPDF = pdf.compactMapValues {
                        URL(string: $0)
                    }.sorted {
                        $0.key < $1.key
                    }
                    
                    ForEach(sortedPDF, id: \.key) { (key, value) in
                        Link(destination: value) {
                            Text(key)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    BookDetailView(isbn13: "", 
                   viewModel: DetailViewDependencyContainer().resolveBookDetailViewModel())
}

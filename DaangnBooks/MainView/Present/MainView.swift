//
//  MainView.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/13/24.
//

import SwiftUI

struct MainView: View {
    @State private var searchingText: String = ""
    @State private var viewModel: MainViewViewModel = .init()
    
    var body: some View {
        VStack(spacing: 20) {
            Images
                .daangnSymbol
                .resizable()
                .frame(width: 100,
                       height: 100)
            Text("당근 북스")
                .font(.title)
            TextField("검색어 입력",
                      text: $searchingText)
            .onSubmit {
                viewModel.didOnSubmitTextField(text: searchingText)
            }
            .padding(.horizontal, 20)
            
            List {
                ForEach(viewModel.bookData, 
                        id: \.isbn13) { book in
                    Text("\(book.title)")
                }
            }
            Spacer()
        }
        .padding(.all,
                 10)
    }
}

#Preview {
    MainView()
}

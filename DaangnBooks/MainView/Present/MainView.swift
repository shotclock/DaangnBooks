//
//  MainView.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/13/24.
//

import SwiftUI
import Networking

struct MainView: View {
    @State private var searchingText: String
    @State private var viewModel: MainViewViewModel
    
    init(viewModel: MainViewViewModel) {
        _searchingText = .init(initialValue: "")
        _viewModel = .init(initialValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Images
                .daangnSymbol
                .resizable()
                .frame(width: 100,
                       height: 100)
            Text("당근 북스")
                .font(.title)
            
            searchTextFieldWithClearButton
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
    
    private var searchTextFieldWithClearButton: some View {
        ZStack(alignment: .trailing) {
            TextField("검색어 입력",
                      text: $searchingText)
            .onSubmit {
                viewModel.didOnSubmitTextField(text: searchingText)
            }
            
            if !searchingText.isEmpty {
                Button {
                    searchingText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.gray)
                }

            }
        }
    }
}

#Preview {
    MainView(viewModel: MainViewDependencyContainer().resolveMainViewViewModel())
}

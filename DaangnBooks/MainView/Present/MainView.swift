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
            
            listArea
                .frame(maxHeight: .infinity)
                .overlay {
                    if viewModel.isLoadingContent {
                        LoadingView()
                    }
                }
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
    
    private var listArea: some View {
        List {
            ForEach(viewModel.bookData ?? [],
                    id: \.isbn13) { book in
                SearchBookResultRow(model: book)
            }
            if viewModel.hasMoreList {
                lastRow
                    .frame(maxWidth: .infinity)
            }
        }
        .overlay {
            if viewModel.bookData == nil,
               viewModel.errorDescription == nil {
                ContentUnavailableView("위 검색창을 통해 검색해주세요!",
                                       systemImage: Images.Strings.search)
            } else if viewModel.bookData?.isEmpty ?? false {
                ContentUnavailableView("원하시는 결과가 없는 것 같습니다...",
                                       systemImage: Images.Strings.search,
                                       description: Text("검색어를 수정해보세요!"))
            } else if let errorDescription = viewModel.errorDescription {
                ContentUnavailableView(errorDescription,
                                       systemImage: Images.Strings.exclamationmark)
            }
        }
    }
    
    private var lastRow: some View {
        ZStack(alignment: .center) {
            ProgressView()
                .onAppear {
                    viewModel.loadMoreData()
                }
                .id(UUID())
        }
    }
}

#Preview {
    MainView(viewModel: MainViewDependencyContainer().resolveMainViewViewModel())
}

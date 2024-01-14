//
//  DetailViewDependencyContainer.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/15/24.
//

import Foundation
import Networking

struct DetailViewDependencyContainer {
    func resolveBookDetailRepository() -> BookDetailRepository {
        DefaultBookDetailRepository(networking: NetworkingBuilder.build())
    }
    
    func resolveBookDetailFetchUseCase() -> BookDetailFetchUseCase {
        DefaultBookDetailFetchUseCase(bookDetailRepository: resolveBookDetailRepository())
    }
    
    func resolveBookDetailViewModel() -> BookDetailViewModel {
        .init(bookDetailFetchUseCase: resolveBookDetailFetchUseCase())
    }
}

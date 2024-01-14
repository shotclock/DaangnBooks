//
//  MainViewDependencyContainer.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/13/24.
//

import Foundation
import Networking

struct MainViewDependencyContainer {
    
    func resolveSearchBookRepository() -> SearchBookRepository {
        DefaultSearchBookRepository(networking: NetworkingBuilder.build())
    }
    
    func resolveSearchBookUseCase() -> SearchBookUseCase {
        DefaultSearchBookUseCase(searchBookRepository: resolveSearchBookRepository())
    }
    
    func resolveMainViewViewModel() -> MainViewViewModel {
        .init(searchBookUseCase: resolveSearchBookUseCase())
    }
}

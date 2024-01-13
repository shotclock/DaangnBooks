//
//  MainView.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/13/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Images
                .daangnSymbol
                .resizable()
                .frame(width: 100,
                       height: 100)
            Spacer()
            
        }
        .padding(.all,
                 10)
    }
}

#Preview {
    MainView()
}

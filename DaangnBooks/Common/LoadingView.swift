//
//  LoadingView.swift
//  DaangnBooks
//
//  Created by lee sangho on 1/14/24.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    private let zoomScale = CGSize(width: 1.3, height: 1.3)
    private let normalScale = CGSize(width: 1, height: 1)
    
    var body: some View {
        ZStack {
            Color
                .white
            Images
                .daangnSymbol
                .resizable()
                .frame(width: 100,
                       height: 100)
                .aspectRatio(contentMode: .fit)
                .scaleEffect(isAnimating ? zoomScale : normalScale)
        }
        .onAppear {
            withAnimation(.easeInOut.repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    LoadingView()
}

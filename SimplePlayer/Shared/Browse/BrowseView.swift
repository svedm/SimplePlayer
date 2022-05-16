//
//  BrowseView.swift
//  SimplePlayer
//
//  Created by Svetoslav on 16.05.2022.
//

import SwiftUI

struct BrowseView: View {
    @StateObject private var viewModel: BrowseViewModel
    
    init(viewModel: BrowseViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List(viewModel.content, id: \.id) { item in
            NavigationLink(destination: viewModel.destination(for: item)) {
                BrowseCell(item: item)
            }
        }
        .navigationTitle(viewModel.title)
        .onAppear {
            Task {
                await viewModel.load()
            }
        }
    }
}

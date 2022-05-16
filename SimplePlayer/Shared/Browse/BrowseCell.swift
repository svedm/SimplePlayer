//
//  BrowseCell.swift
//  SimplePlayer
//
//  Created by Svetoslav on 16.05.2022.
//

import SwiftUI

struct BrowseCell: View {
    private let item: BrowseItem
    
    var body: some View {
        HStack {
            iconForItem()
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 32, maxHeight: 32)
            Text(item.title)
        }
    }

    internal init(item: BrowseItem) {
        self.item = item
    }
    
    private func iconForItem() -> Image {
        switch item.kind {
        case .item:
            return Image(systemName: "play.rectangle")
        case .container:
            return Image(systemName: "folder")
        }
    }
}

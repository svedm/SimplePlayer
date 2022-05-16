//
//  BrowseItem.swift
//  SimplePlayer
//
//  Created by Svetoslav on 16.05.2022.
//

import Foundation
import UPnPClient

struct BrowseItem {
    var parentId: String?
    var kind: Kind
    
    var id: String {
        switch kind {
        case .container(let container):
            return container.id
        case .item(let item):
            return item.id
        }
    }
    
    var title: String {
        switch kind {
        case .item(let item):
            return item.title
        case .container(let container):
            return container.title
        }
    }
    
    enum Kind {
        case container(DIDLLite.Container)
        case item(DIDLLite.Item)
    }
    
    init(container: DIDLLite.Container, parentId: String?) {
        kind = .container(container)
        self.parentId = parentId
    }
    
    init(item: DIDLLite.Item, parentId: String?) {
        kind = .item(item)
        self.parentId = parentId
    }
}

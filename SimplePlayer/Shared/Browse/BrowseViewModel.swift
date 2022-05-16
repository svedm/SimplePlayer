//
//  BrowseViewModel.swift
//  SimplePlayer
//
//  Created by Svetoslav on 16.05.2022.
//

import SwiftUI
import UPnPClient

@MainActor
final class BrowseViewModel: ObservableObject {
    @Published private(set) var content: [BrowseItem] = []
    @Published private(set) var title: String
    
    let deviceDescription: DeviceDescription
    private let browseItem: BrowseItem?
    private let upnpClient: UPnPClient = BaseUPnPClient()
    
    init(deviceDescription: DeviceDescription, browseItem: BrowseItem?) {
        self.deviceDescription = deviceDescription
        self.browseItem = browseItem
        title = browseItem?.title ?? deviceDescription.device.friendlyName
    }
    
    func load() async {
        guard
            let service = deviceDescription.device.serviceList.services
                .first(where: { $0.knownType == .contentDirectory }),
            let url = deviceDescription.urlBase?.appendingPathComponent(service.scpdURL)
        else { return }
        
        do {
            var content: [BrowseItem] = []
            let result = try await upnpClient.browse(
                url: url,
                serviceVersion: service.version ?? 1,
                objectID: browseItem?.id ?? "0"
            )
            content.append(
                contentsOf: result.containers.map { BrowseItem(container: $0, parentId: self.browseItem?.parentId)}
            )
            content.append(
                contentsOf: result.items.map { BrowseItem(item: $0, parentId: self.browseItem?.parentId)}
            )
            self.content = content
        } catch {
            print(error)
        }
    }
    
    func destination(for item: BrowseItem) -> some View {
        switch item.kind {
        case .item(let item):
            if let videoResource = item.res.first(where: { $0.kind == .video }) {
                return AnyView(PlayerView(viewModel: .init(item: item, resource: videoResource)))
            } else {
                return AnyView(Text("Not supported"))
            }
        case .container:
            return AnyView(BrowseView(viewModel: .init(deviceDescription: deviceDescription, browseItem: item)))
        }
    }
}

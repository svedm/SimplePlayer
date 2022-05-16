//
//  ContentView.swift
//  Shared
//
//  Created by Svetoslav on 17.06.2021.
//

import SwiftUI

struct DevicesListView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: DevicesListViewModel
    
    init(viewModel: DevicesListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var backButton: some View {
        Button("Back") {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    
    var body: some View {
        NavigationView {
            List(viewModel.devices, id: \.device.udn) { description in
                let icon = description.device.bestIcon ?? ""
                let url = icon.starts(with: "/") ? description.urlBase?.appendingPathComponent(icon): URL(string: icon)
                NavigationLink(
                    destination: BrowseView(viewModel: .init(deviceDescription: description, browseItem: nil))
                ) {
                    HStack {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                Image(systemName: "network")
                            case .success(let image):
                                image.resizable().scaledToFit()
                            case .failure:
                                Image(systemName: "x.circle")
                            @unknown default:
                                Image(systemName: "network")
                            }
                        }
                        .frame(maxWidth: 32, maxHeight: 32)
                        Text(description.device.friendlyName)
                    }
                }
            }
        }
        .navigationTitle("Devices list")
        .onAppear {
            Task {
                await viewModel.loadDevices()
            }
        }
    }
}

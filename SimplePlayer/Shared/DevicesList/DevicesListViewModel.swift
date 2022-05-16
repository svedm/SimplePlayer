//
//  DevicesListViewModel.swift
//  SimplePlayer
//
//  Created by Svetoslav on 16.05.2022.
//

import Foundation
import UPnPClient

@MainActor
final class DevicesListViewModel: ObservableObject {
    @Published private(set) var devices: [DeviceDescription] = []
    
    private let client = BaseUPnPClient()
    
    
    func loadDevices() async {
        do {
            devices = try await client.discoverDevices(timeout: 3)
        } catch {
            print(error)
        }
    }
}

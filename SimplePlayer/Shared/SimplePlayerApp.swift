//
//  SimplePlayerApp.swift
//  Shared
//
//  Created by Svetoslav on 17.06.2021.
//

import SwiftUI

@main
struct SimplePlayerApp: App {
    var body: some Scene {
        WindowGroup {
            DevicesListView(viewModel: .init())
        }
    }
}

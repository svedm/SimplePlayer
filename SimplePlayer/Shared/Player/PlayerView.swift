//
//  PlayerView.swift
//  SimplePlayer
//
//  Created by Svetoslav on 16.05.2022.
//

import SwiftUI
import UPnPClient
import AVKit

@MainActor
final class PlayerViewModel: ObservableObject {
    var player: AVPlayer
    
    private let item: DIDLLite.Item
    
    init(item: DIDLLite.Item, resource: Resource) {
        self.item = item
        self.player = URL(string: resource.value).map(AVPlayer.init) ?? .init()
    }
}

struct PlayerView: View {
    @StateObject private var viewModel: PlayerViewModel
    
    init(viewModel: PlayerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VideoPlayer(player: viewModel.player)
    }
}

//struct CustomVideoPlayer: UIViewControllerRepresentable {
//
//  func makeUIViewController(context: Context) -> AVPlayerViewController {
//    let controller = AVPlayerViewController()
//    let url: String = "https://xxx.mp4"
//    let player1 = AVPlayer(url: URL(string: url)!)
//
//    controller.player = player1
//    return controller
//  }
//
//  func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
//
//  }
//}

//
//  PlayerView.swift
//  SimplePlayer
//
//  Created by Svetoslav on 16.05.2022.
//

import SwiftUI
import UPnPClient
import AVKit
#if os(macOS)
    import Cocoa
#elseif os(iOS) || os(tvOS)
    import UIKit
#endif

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
        CustomVideoPlayer(player: viewModel.player)
            .onAppear {
                viewModel.player.play()
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
    }
}


struct CustomVideoPlayer {
    private let player: AVPlayer

    init(player: AVPlayer) {
        self.player = player
    }
}
#if os(iOS) || os(tvOS)
extension CustomVideoPlayer: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AVPlayerViewController {
      let controller = AVPlayerViewController()
      controller.player = player
      return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
    }
}
#endif

#if os(macOS)
extension CustomVideoPlayer: NSViewRepresentable {
    
    func makeNSView(context: Context) -> AVPlayerView {
        let view = AVPlayerView()
        view.player = player
        return view
    }
    
    func updateNSView(_ nsView: AVPlayerView, context: Context) {
    }
}
#endif

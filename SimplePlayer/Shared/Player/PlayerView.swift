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
final class PlayerViewModel: NSObject, ObservableObject, VLCMediaPlayerDelegate {
    let player: VLCMediaPlayer = .init()

    @Published var isPlaying: Bool = false
    @Published var progress: Float = 0
    @Published var currentTime: String = ""
    @Published var duration: String = ""
    
    private let item: DIDLLite.Item
    private let url: URL
    
    init(item: DIDLLite.Item, resource: Resource) {
        self.item = item
        self.url = resource.value
        
        player.media = VLCMedia(url: url)
        isPlaying = player.isPlaying
    }
    
    func load() {
        player.delegate = self
        playOrPause()
    }
    
    func playOrPause() {
        if !player.isPlaying {
            player.play()
        } else {
            player.pause()
        }
    }
    
    func mediaPlayerTimeChanged(_ aNotification: Notification) {
        progress = player.position
        currentTime = player.time.stringValue
        duration = player.media?.length.stringValue ?? ""
    }
    
    func mediaPlayerStateChanged(_ aNotification: Notification) {
        print("state: ", player.drawable)
        print("state: ", player.media?.url)
        isPlaying = player.isPlaying
        switch player.state {
        case .stopped:
            print("state stopped")
        case .opening:
            print("opening")
        case .buffering:
            print("buffering")
        case .ended:
            print("ended")
        case .error:
            print("error")
        case .playing:
            print("playing")
        case .paused:
            print("paused")
        case .esAdded:
            print("esAdded")
        @unknown default:
            print("default")
        }
        print(player.state.rawValue)
    }
}

struct PlayerView: View {
    @StateObject private var viewModel: PlayerViewModel
    @State private var showControls: Bool = true
    
    init(viewModel: PlayerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            CustomVideoPlayer(player: viewModel.player)
            #if !os(macOS)
                .navigationBarHidden(true)
            #elseif os(tvOS)
                .focusable(false)
            #endif
                .edgesIgnoringSafeArea(.all)
            ControlsView(
                isPlaying: $viewModel.isPlaying,
                position: $viewModel.progress,
                currentTime: $viewModel.currentTime,
                duration: $viewModel.duration
            ) {
                viewModel.playOrPause()
            }
        }
        .onAppear {
            viewModel.load()
        }
    }
}

struct ControlsView: View {
    typealias Action = () -> Void
    @Binding var isPlaying: Bool
    @Binding var position: Float
    @Binding var currentTime: String
    @Binding var duration: String
    
    let playAction: Action
    
    var body: some View {
        HStack {
            Button {
                self.playAction()
            } label: {
                Image(systemName: isPlaying ? "pause" : "play")
            }
            ProgressView(
                value: position,
                label: {
                    Text(duration)
                },
                currentValueLabel: {
                    Text(currentTime)
                }
            )
            #if os(tvOS)
            .focusable()
            .focusSection()
            #endif
            .progressViewStyle(.linear)
        }
    }
}


#if os(tvOS)
import TVVLCKit
#elseif os(iOS)
import MobileVLCKit
#endif

#if os(tvOS) || os(iOS)
final class CustomVideoPlayer: UIView, UIViewRepresentable {
    let movieView: UIView = .init()
    private var player: VLCMediaPlayer?
    
    init(player: VLCMediaPlayer?) {
        self.player = player
        super.init(frame: .zero)
        addSubview(movieView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        movieView.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUIView(context: Context) -> CustomVideoPlayer {
        CustomVideoPlayer(player: player)
    }
    
    func updateUIView(_ uiView: CustomVideoPlayer, context: Context) {
        player?.drawable = uiView.movieView
    }
}
#endif

#if os(macOS)
import VLCKit

final class CustomVideoPlayer: NSView, NSViewRepresentable {
    private let movieView: NSView = .init()
    private let player = VLCMediaPlayer()
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(frame: .zero)
        player.media = VLCMedia(url: url)
        player.drawable = movieView
        player.play()
        
        addSubview(movieView)
    }
    
    deinit {
        player.stop()
        player.media = nil
        player.drawable = nil
    }
    
    override func layout() {
        super.layout()
        movieView.frame = frame
        movieView.frame = NSScreen.main?.frame ?? frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeNSView(context: Context) -> CustomVideoPlayer {
        CustomVideoPlayer(url: url)
    }
    
    func updateNSView(_ nsView: CustomVideoPlayer, context: Context) {
    }
}
#endif


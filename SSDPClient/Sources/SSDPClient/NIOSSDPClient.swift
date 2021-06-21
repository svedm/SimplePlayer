import Foundation
import NIO

final public class NIOSSDPClient: SSDPClient {
    private let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    private var foundedDevices: [SSDPSearchResponse] = []
    private lazy var ssdpHandler = SSDPHandler { [weak self] message in
        self?.foundedDevices.append(message)
    }
    private var discoveryContinuation: CheckedContinuation<[SSDPSearchResponse], Error>?

    private enum Constants {
        static let listenHost = "0.0.0.0"
        static let listenPort = 1900
        static let ssdpHost = "239.255.255.250"
        static let ssdpPort = 1900
    }

    public init() {}

    public func discover(target: SSDPSearchTarget, timeout: Int) async throws -> [SSDPSearchResponse] {
        foundedDevices = []

        let channel = try DatagramBootstrap(group: group)
            .channelOption(ChannelOptions.socket(SOL_SOCKET, SO_BROADCAST), value: 1)
            .channelInitializer { channel in
                channel.pipeline.addHandler(self.ssdpHandler)
            }
            .bind(to: .init(ipAddress: Constants.listenHost, port: Constants.listenPort))
            .wait()

        group.next().execute {
            guard
                let multicastGroup = try? SocketAddress(ipAddress: Constants.ssdpHost, port: Constants.ssdpPort)
            else { return }

            let message = "M-SEARCH * HTTP/1.1\r\n"
                + "MAN: \"ssdp:discover\"\r\n"
                + "HOST: \(Constants.ssdpHost):\(Constants.ssdpPort)\r\n"
                + "ST: \(target.stringValue)\r\n"
                + "MX: \(timeout)\r\n\r\n"
            let buffer = channel.allocator.buffer(string: message)
            let envolope = AddressedEnvelope<ByteBuffer>(remoteAddress: multicastGroup, data: buffer)
            channel.writeAndFlush(envolope, promise: nil)
        }

        group.next().scheduleTask(in: .seconds(Int64(timeout))) {
            channel
                .close()
                .whenComplete { [weak self] _ in
                    guard let self = self else { return }
                    self.group.shutdownGracefully { error in
                        if let error = error {
                            self.discoveryContinuation?.resume(throwing: error)
                        } else {
                            self.discoveryContinuation?.resume(returning: self.foundedDevices)
                        }
                        self.discoveryContinuation = nil
                    }
                }
        }

        return try await withCheckedThrowingContinuation { continuation in
            self.discoveryContinuation = continuation
        }
    }

    deinit {
        try? group.syncShutdownGracefully()
    }
}

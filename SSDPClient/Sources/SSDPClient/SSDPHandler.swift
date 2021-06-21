import NIO
import Logging

final class SSDPHandler: ChannelInboundHandler {
    public typealias InboundIn = AddressedEnvelope<ByteBuffer>
    public typealias OutboundOut = AddressedEnvelope<ByteBuffer>
    typealias MessageHandler = (SSDPSearchResponse) -> Void

    private lazy var logger = Logger(label: String(describing: self))
    private var handler: MessageHandler

    init(handler: @escaping MessageHandler) {
        self.handler = handler
    }

    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let envelope = self.unwrapInboundIn(data)
        let byteBuffer = envelope.data

        guard byteBuffer.readableBytes > 0 else { return }

        let string = String(buffer: byteBuffer)
        logger.info("Received: '\(string)'")
        do {
            let response = try SSDPSearchResponse(response: string)
            handler(response)
        } catch {
            logger.error("Response parsing failed \(error)")
        }

    }

    public func errorCaught(context: ChannelHandlerContext, error: Error) {
        logger.error("\(error)")
        context.close(promise: nil)
    }
}

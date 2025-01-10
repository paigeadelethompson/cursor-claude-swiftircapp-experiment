import Foundation
import NIO
import NIOTransportServices

class IRCConnection {
    private var channel: Channel?
    private let eventLoop: EventLoop
    private let host: String
    private let port: Int
    private let useTLS: Bool
    private let credentials: IRCCredentials
    
    init(host: String, port: Int, useTLS: Bool, credentials: IRCCredentials) {
        self.host = host
        self.port = port
        self.useTLS = useTLS
        self.credentials = credentials
        
        let group = NIOTSEventLoopGroup()
        self.eventLoop = group.next()
    }
    
    func connect() -> EventLoopFuture<Void> {
        let bootstrap = NIOTSConnectionBootstrap(group: eventLoop)
            .channelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
            .channelInitializer { channel in
                let handler = IRCHandler(credentials: self.credentials)
                return channel.pipeline.addHandler(handler)
            }
        
        return bootstrap.connect(host: host, port: port).map { channel in
            self.channel = channel
            return ()
        }
    }
    
    func disconnect() -> EventLoopFuture<Void> {
        guard let channel = channel else {
            return eventLoop.makeSucceededFuture(())
        }
        return channel.close()
    }
    
    func send(_ command: String) -> EventLoopFuture<Void> {
        guard let channel = channel else {
            return eventLoop.makeFailedFuture(IRCError.notConnected)
        }
        
        let data = ByteBuffer(string: command + "\r\n")
        return channel.writeAndFlush(data)
    }
}

struct IRCCredentials {
    let nickname: String
    let alternateNickname: String
    let username: String
    let realName: String
    let serverPassword: String?
    let saslUsername: String?
    let saslPassword: String?
}

enum IRCError: Error {
    case notConnected
    case connectionFailed
    case authenticationFailed
} 
import XCTest
@testable import IRCClient

class IRCMessageTests: XCTestCase {
    func testPrivateMessageParsing() {
        let message = IRCMessage(
            prefix: ":nick!user@host.com",
            command: "PRIVMSG",
            parameters: ["#channel", "Hello, World!"],
            timestamp: Date()
        )
        
        XCTAssertTrue(message.isPrivateMessage)
        XCTAssertTrue(message.isChannelMessage)
        XCTAssertEqual(message.parameters.last, "Hello, World!")
    }
    
    func testColorFormatting() {
        let coloredText = "\u{03}04,12Colored Text"
        let formatted = IRCFormatter.format(coloredText)
        
        // Add assertions for color formatting
        XCTAssertNotEqual(formatted.characters.count, coloredText.count)
    }
} 
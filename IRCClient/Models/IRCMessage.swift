import Foundation

struct IRCMessage {
    let prefix: String?
    let command: String
    let parameters: [String]
    let timestamp: Date
    
    var isPrivateMessage: Bool {
        return command == "PRIVMSG"
    }
    
    var isChannelMessage: Bool {
        guard isPrivateMessage,
              let target = parameters.first else { return false }
        return target.hasPrefix("#") || target.hasPrefix("&")
    }
    
    var formattedText: AttributedString {
        guard let text = parameters.last else {
            return AttributedString("")
        }
        return IRCFormatter.format(text)
    }
}

class IRCFormatter {
    static func format(_ text: String) -> AttributedString {
        var attributed = AttributedString(text)
        
        // Process IRC color codes and formatting
        // This is a simplified version - you'll need to implement the full IRC color spec
        let colorPattern = /\x03(\d{1,2})(,\d{1,2})?/
        let boldPattern = /\x02/
        let italicPattern = /\x1D/
        let underlinePattern = /\x1F/
        
        // Implementation details for formatting would go here
        
        return attributed
    }
} 
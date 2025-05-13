import Foundation

struct ChatGroup: Codable, Identifiable {
    var id = UUID()
    var name: String // Name of the group
    var memberEmails: [String] // Email IDs of the users in the group
    var messages: [Message] = [] // Messages in the group
    init(name: String, members: [String]) {
        self.name = name
        self.memberEmails = members
        self.messages = []
    }
}
struct Message: Codable, Identifiable {
var id = UUID()
var senderEmail: String
var content: String
var timestamp: Date
}

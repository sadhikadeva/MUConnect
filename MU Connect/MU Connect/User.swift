//
//  User.swift
//  MU Connect
//
//  Created by Niyathi on 5/5/25.
//

import Foundation

struct MUUser: Codable, Identifiable {
    let id: UUID
    var name: String
    var email: String
    var password: String
    var bio: String
    var batch: String
    var profileImageData: String?  // Base64-encoded image

    init(name: String, email: String, password: String) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.password = password
        self.bio = ""
        self.batch = ""
        self.profileImageData = nil
    }
}

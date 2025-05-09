//
//  Post.swift
//  MU Connect
//
//  Created by Niyathi on 5/5/25.
//

import Foundation

struct Post: Identifiable {
    var id = UUID()
    var content: String
    var author: String
    var timestamp: Date
    var imageData: String? // Optional image data in Base64
}

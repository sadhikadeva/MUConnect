import Foundation
import UIKit

struct Post: Codable, Identifiable {
    let id: UUID
    let authorEmail: String
    var imageData: String? // base64 encoded image
    var caption: String

    init(authorEmail: String, image: UIImage?, caption: String) {
        self.id = UUID()
        self.authorEmail = authorEmail
        self.caption = caption
        if let img = image, let data = img.jpegData(compressionQuality: 0.8) {
            self.imageData = data.base64EncodedString()
        } else {
            self.imageData = nil
        }
    }

    var image: UIImage? {
        guard let imageData = imageData,
              let data = Data(base64Encoded: imageData) else { return nil }
        return UIImage(data: data)
    }
}



//import Foundation
//import UIKit
//
//struct Post: Codable, Identifiable {
//    var id = UUID()
//    var authorEmail: String
//    var caption: String
//    var imageData: String?
//
//    var image: UIImage? {
//        if let data = Data(base64Encoded: imageData ?? "") {
//            return UIImage(data: data)
//        }
//        return nil
//    }
//}


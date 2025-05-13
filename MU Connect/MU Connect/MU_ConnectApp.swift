//import SwiftUI
//
//@main
//struct MU_ConnectApp: App {
//    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
//    var body: some Scene {
//        WindowGroup {
//            if isLoggedIn {
//                MainTabView()
//            } else {
//                LoginView()
//            }
//        }
//    }
//}




 //to instantly go back to login page without losing anything
import SwiftUI

@main
struct MU_ConnectApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView() // 🚨 Force show login screen for now
        }
    }
}

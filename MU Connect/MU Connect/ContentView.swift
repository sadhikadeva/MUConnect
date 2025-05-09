import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "graduationcap")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .offset(y: -30)
            Text("MU Connect")
                .font(.title)
                .fontWeight(.bold)
                .offset(y: -25)
            Text("Building Bridges, Creating Opportunities.")
                .offset(y: -20)
        }
        .padding()

        LoginView()
    }
}

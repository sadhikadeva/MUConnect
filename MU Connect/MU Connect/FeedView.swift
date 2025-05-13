
import SwiftUI

struct FeedView: View {
    @State private var posts: [String] = []
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if posts.isEmpty {
                        Text("No posts yet.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(posts.reversed(), id: \.self) { post in
                            Text(post)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Feed")
            .onAppear(perform: loadPosts)
        }
    }
    
    func loadPosts() {
        posts = UserDefaults.standard.stringArray(forKey: "posts") ?? []
    }
}
#Preview {
FeedView()
}

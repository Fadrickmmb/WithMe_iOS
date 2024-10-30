import SwiftUI
import FirebaseDatabase
import FirebaseAuth
import Firebase

struct Admin_PostView: View {
    var post: Post
    @State private var showChangePostDialog = false
    @State private var yummysCount: Int
    @State private var hasGivenYummy: Bool = false
    private let userId: String? = Auth.auth().currentUser?.uid
    var onLocationTap: () -> Void


    init(post: Post, onLocationTap: @escaping () -> Void) {
        self.post = post
        self.onLocationTap = onLocationTap
        _yummysCount = State(initialValue: post.yummys)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(post.name)
                    .font(.headline)
                Spacer()
                Text(post.location)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        onLocationTap()
                    }
            }

            AsyncImage(url: URL(string: post.postImageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
            } placeholder: {
                ProgressView()
            }

            Text(post.content)
                .font(.body)

            HStack {
                Button(action: {
                    toggleYummy()
                }) {
                    Text(hasGivenYummy ? "❤️ \(yummysCount) yummys" : "🤍 \(yummysCount) yummys")
                }
                Spacer()
                Button(action: {
                    showChangePostDialog.toggle()
                }) {
                    Text("💬 \(post.commentsNumber) Comments")
                }
            }
            .font(.footnote)
            .padding(.top, 5)
            .sheet(isPresented: $showChangePostDialog) {
                ChangePostDialog(
                    buttonTitle: "Edit/Delete",
                    action: handleAction,
                    userId: post.userId,
                    postId: post.postId,
                    isShowing: $showChangePostDialog
                )
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .onAppear {
            checkYummyStatus()
        }
    }

    func toggleYummy() {
        guard let userId = userId else {
            print("Error: User ID is nil")
            return
        }

        let postRef = Database.database().reference()
            .child("admin")
            .child(post.userId)
            .child("posts")
            .child(post.postId)

        postRef.runTransactionBlock({ currentData in
            var post = currentData.value as? [String: Any] ?? [:]
            var likes = post["yummy"] as? [String] ?? []
            var yummys = post["yummys"] as? Int ?? 0

            if likes.contains(userId) {
                likes.removeAll { $0 == userId }
                yummys -= 1
                self.hasGivenYummy = false
            } else {
                likes.append(userId)
                yummys += 1
                self.hasGivenYummy = true
            }

            post["yummy"] = likes
            post["yummys"] = yummys
            currentData.value = post
            return TransactionResult.success(withValue: currentData)
        }) { error, committed, snapshot in
            if let error = error {
                print("Error updating yummys count: \(error.localizedDescription)")
            } else if committed, let postData = snapshot?.value as? [String: Any] {
                DispatchQueue.main.async {
                    self.yummysCount = postData["yummys"] as? Int ?? self.yummysCount
                }
            }
        }
    }

    func checkYummyStatus() {
        guard let userId = userId else {
            print("Error: User ID is nil")
            return
        }

        let postRef = Database.database().reference()
            .child("admin")
            .child(post.userId)
            .child("posts")
            .child(post.postId)

        postRef.observeSingleEvent(of: .value) { snapshot in
            if let postData = snapshot.value as? [String: Any],
               let likes = postData["yummy"] as? [String],
               let yummys = postData["yummys"] as? Int {
                DispatchQueue.main.async {
                    self.yummysCount = yummys
                    self.hasGivenYummy = likes.contains(userId)
                }
            }
        }
    }

    func handleAction(_ actionType: String) {
        switch actionType {
        case "delete":
            print("Delete post")
        case "edit":
            print("Edit post")
        default:
            break
        }
    }
}

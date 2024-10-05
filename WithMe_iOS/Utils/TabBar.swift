import SwiftUI
import Firebase
import FirebaseAuth

struct TabBar: View {
    @State private var profileImage: UIImage? = nil
    
    var body: some View {
        HStack {
            
//            NavigationLink(destination: HomeView()) {
                Image("withme_home")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.black)
//            }
            Spacer()
            
            Image("withme_search")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(.black)
            Spacer()
            
            
//            NavigationLink(destination: AddPostView()) {
                Image("withme_newpost")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
//            }
            Spacer()
            
           
            NavigationLink(destination: EditProfileView()) {
                if let profileImage = profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .foregroundColor(.black)
                } else {
                    
                    Image("sampleImg")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .foregroundColor(.black)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            fetchProfileImage()
        }
    }
    
    
    private func fetchProfileImage() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Database.database().reference().child("users").child(uid)
        
        db.observeSingleEvent(of: .value) { snapshot in
            if let value = snapshot.value as? [String: Any],
               let profileImageUrl = value["profileImageUrl"] as? String {
                downloadProfileImage(from: profileImageUrl)
            }
        }
    }
    

    private func downloadProfileImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Error converting image data.")
                return
            }
            
            DispatchQueue.main.async {
                self.profileImage = image 
            }
        }.resume()
    }
}

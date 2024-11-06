import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class FirebaseManager {
    static let shared = FirebaseManager()
    
    let auth: Auth
    let databaseRef: DatabaseReference
    let storageRef: StorageReference

    private init() {
        
        self.auth = Auth.auth()
        self.databaseRef = Database.database().reference()
        self.storageRef = Storage.storage().reference()
    }
}


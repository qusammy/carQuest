import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

enum userError: Error {
    case runtimeError(String)
}

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoURL: String?
    let displayName: String?
    let description: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
        self.displayName = user.displayName
        self.description = user.description
        
    }
}

final class AuthenticationManager {

    static let shared = AuthenticationManager()
    var imageURLs = [String]()
    private init() {

    }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw userError.runtimeError("No user signed in")
        }
        return AuthDataResultModel(user: user)
    }
    

    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func signInUser(email: String, password: String){
       Auth.auth().signIn(
            withEmail: email,
            password: password
       ) { (result, error) in
           let authError = error! as NSError
           if authError.code == AuthErrorCode.secondFactorRequired.rawValue {
               // The user is a multi-factor user. Second factor challenge is required.
               let resolver =
               authError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
               let hint = resolver.hints[0] as! PhoneMultiFactorInfo
               PhoneAuthProvider.provider().verifyPhoneNumber(
                with: hint,
                uiDelegate: nil,
                multiFactorSession: resolver.session
               ) { (verificationId, error) in
                   // verificationId will be needed for sign-in completion.
               }
           }
           
       }
    }
    
    func updateProfilePicture(photoURL: URL){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{
            return
        }
        
        let userPhotoData = ["profileImageURL": photoURL.absoluteString]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).updateData(userPhotoData){ err in
                if let err = err {
                    print(err)
                    return
                }
            }
    }
    
    func updateImage(imageURLs: URL, additionalListing: Int, listingLetter: String) {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{
            return
        }
        let imageURLs = [imageURLs.absoluteString]
        let listingImageData = ["imageName": FieldValue.arrayUnion(imageURLs)]
        FirebaseManager.shared.firestore.collection("carListings")
            .document("\(listingLetter)\(additionalListing)\(uid)").setData(listingImageData, merge: true) { err in
                if let err = err {
                    print(err)
                    return
                }}
    }

    
    func resetPassword(email: String) async throws{
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func verifyEmail() async throws{
        try await Auth.auth().currentUser?.sendEmailVerification()
    }
    
    func deleteUser() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        try await user.delete()
    }
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws  -> AuthDataResultModel{
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signInGoogle(credential: credential)
    }
    
    func signInGoogle(credential: AuthCredential) async throws  -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }

}



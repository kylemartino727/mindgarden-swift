//
//  AuthenticationViewModel.swift
//  MindGarden
//
//  Created by Mark Jones on 7/4/21.
//

import GoogleSignIn
import FirebaseAuth
import Firebase
import FirebaseFirestore
import CryptoKit 
import SwiftUI
import AuthenticationServices
import Combine
import Amplitude
import OneSignal

class AuthenticationViewModel: NSObject, ObservableObject {
    @ObservedObject var viewRouter: ViewRouter
    @ObservedObject var userModel: UserViewModel
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var forgotEmail: String = ""
    @Published var alertError: Bool = false
    @Published var alertMessage: String = "Please try again using a different email or method"
    @Published var isLoading: Bool = false
    @Published var isSignUp: Bool = false
    @Published var falseAppleId: Bool = false
    var currentNonce: String?
    var googleIsNew: Bool = true
    let db = Firestore.firestore()
    var appleAlreadySigned: Bool = false
    init(userModel: UserViewModel, viewRouter: ViewRouter) {
        self.userModel = userModel
        self.viewRouter = viewRouter
        super.init()
        setupGoogleSignIn()
    }
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter
    }()

    var siwa: some View {
        return Group {
            if #available(iOS 14.0, *) {
                SignInWithAppleButton(
                    //Request
                    onRequest: { [self] request in
                        Analytics.shared.log(event: .authentication_tapped_apple)
                        request.requestedScopes = [.fullName, .email]
                        let nonce = randomNonceString()
                        currentNonce = nonce
                        request.nonce = sha256(nonce)
                    },

                    //Completion
                    onCompletion: { [self] result in
                        isLoading = false
                        switch result {
                        case .success(let authResults):
                            switch authResults.credential {
                            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                guard let nonce = currentNonce else {
                                    alertError = true
                                    alertMessage = "Please try again using a different email or method"
                                    return
                                }
                                guard let appleIDToken = appleIDCredential.identityToken else {
                                    alertError = true
                                    return
                                }
                                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                                    return
                                }
                                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString,rawNonce: nonce)

                                // User already signed in with this appleId once

                                if (appleIDCredential.email != nil) || UserDefaults.standard.bool(forKey: "falseAppleId")  { // new user
                                    if !isSignUp { // login
                                        alertError = true
                                        alertMessage = "Email is not associated with account, please try using a different sign in method"
                                        UserDefaults.standard.set(true, forKey: "falseAppleId")
                                        isLoading = false
                                        falseAppleId = true
                                        return
                                    } else { // sign up
                                        Auth.auth().signIn(with: credential, completion: { (user, error) in
                                            if (error != nil) {
                                                alertError = true
                                                alertMessage = error?.localizedDescription ?? "Please try again using a different email or method"
                                                isLoading = false
                                                return
                                            }
                                            //User never used this appleid before
                                            createUser()
                                            withAnimation {
                                                UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
                                                UserDefaults.standard.setValue(true, forKey: K.defaults.loggedIn)
                                                UserDefaults.standard.setValue("done", forKey: K.defaults.onboarding)
                                                goToHome()
                                            }
                                        })
                                    }
                                } else { // used this id before
                                    if isSignUp {
                                        alertError = true
                                        alertMessage = "Please use the login page"
                                        isLoading = false
                                        return
                                    } else { // login
                                        Auth.auth().signIn(with: credential, completion: { (user, error) in
                                            if (error != nil) {
                                                alertError = true
                                                alertMessage = error?.localizedDescription ?? "Please try again using a different email or method"
                                                isLoading = false
                                                print(error?.localizedDescription ?? "high roe")
                                                return
                                            }

                                            withAnimation {
                                                UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
                                                UserDefaults.standard.setValue(true, forKey: K.defaults.loggedIn)
                                                UserDefaults.standard.setValue("done", forKey: K.defaults.onboarding)
                                                goToHome()
                                            }
                                        })
                                    }
                                    return
                                }
                            default:
                                break

                            }
                        default:
                            break
                        }
                    }
                )
            } else {
                // Fallback on earlier versions
            }
        }
    }

    private func goToHome() {
        UserDefaults.standard.setValue("done", forKey: K.defaults.onboarding)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        withAnimation {
            viewRouter.currentPage = .meditate
        }
        Analytics.shared.log(event: isSignUp ? .authentication_signup_successful : .authentication_signin_successful)
    }

     func signInWithGoogle() {
        if GIDSignIn.sharedInstance().currentUser == nil {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            GIDSignIn.sharedInstance().presentingViewController = UIApplication.shared.windows.first?.rootViewController
            GIDSignIn.sharedInstance().signIn()
        }
    }

    func signOut() {
        GIDSignIn.sharedInstance().signOut()
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print(signOutError.localizedDescription)
        }
    }

    private func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().delegate = self
    }
}

extension AuthenticationViewModel: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
//            isLoading = true
            Auth.auth().fetchSignInMethods(forEmail: user.profile.email, completion: { [self]
                (providers, error) in
                if let error = error {
                    alertError = true
                    alertMessage = error.localizedDescription
                    isLoading = false
                } else if let providers = providers {
                    if providers.count != 0 {
                        googleIsNew = false
                    }
                    self.firebaseAuthentication(withUser: user)
                } else {
                    if !isSignUp {
                        googleIsNew = true
                        alertError = true
                        alertMessage = "Email is not associated with account"
                        isLoading = false
                        return
                    } else {
                        self.firebaseAuthentication(withUser: user)
                    }
                }
            })
        } else {
            print(error.debugDescription)
        }
    }

    private func firebaseAuthentication(withUser user: GIDGoogleUser) {
        if let authentication = user.authentication {
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)

            Auth.auth().signIn(with: credential) { [self] (_, error) in
                isLoading = false
                if let _ = error {
                    alertError = true
                    alertMessage = error?.localizedDescription ?? "Please try again using a different email or method"
                    isLoading = false
                } else {
                    if googleIsNew {
                        createUser()
                    } else {
                        UserDefaults.standard.setValue("done", forKey: K.defaults.onboarding)
                    }
                    withAnimation {
                        UserDefaults.standard.setValue(true, forKey: K.defaults.loggedIn)
                        goToHome()
                    }
                    alertError = false
                }
            }
        }
    }
}

//MARK: - regular sign up
extension AuthenticationViewModel {
    var validatedPassword: AnyPublisher<String?, Never> {
        return $password
            .map { $0.count < 6 ? "invalid" : $0 }
            .eraseToAnyPublisher()
    }

    var validatedEmail: AnyPublisher<String?, Never> {
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return $email
            .map { !emailPredicate.evaluate(with: $0) ? "invalid"  : $0}
            .eraseToAnyPublisher()
    }

    var validatedCredentials: AnyPublisher<(String, String)?, Never> {
        validatedEmail.combineLatest(validatedPassword) { email, password in
            guard let mail = email, let pwd = password else { return nil }
            return (mail, pwd)
        }
        .eraseToAnyPublisher()
    }

    func signUp() {
        Auth.auth().createUser(withEmail: self.email, password: self.password) { [self] result,error in
            isLoading = false
            if error != nil  {
                alertError = true
                alertMessage = error?.localizedDescription ?? "Please try again using a different email or method"
                return
            }
            createUser()
            alertError = false
            withAnimation {
                UserDefaults.standard.setValue(true, forKey: K.defaults.loggedIn)
                goToHome()
            }
        }
    }

    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { [self] authResult, error in
//            isLoading = false
            if error != nil {
                alertError = true
                alertMessage = error?.localizedDescription ?? "Please try again using a different email or method"
                return
            }
            getData()
            alertError = false
            withAnimation {
                UserDefaults.standard.setValue(true, forKey: K.defaults.loggedIn)
                if isSignUp {
                    if UserDefaults.standard.string(forKey: K.defaults.onboarding) == nil  {
                        UserDefaults.standard.setValue("signedUp", forKey: K.defaults.onboarding)
                    }
                } else {
                    UserDefaults.standard.setValue("done", forKey: K.defaults.onboarding)
                }
                UserDefaults.standard.setValue("nature", forKey: "sound")
                goToHome()
            }
        }
    }

    func forgotPassword() {
        Auth.auth().sendPasswordReset(withEmail: forgotEmail) { [self] error in
            isLoading = false
            if error != nil {
                alertError = true
                alertMessage = error?.localizedDescription ?? "Please try again using a different email or method"
            } else {
                alertError = false
            }
        }
    }

    func createUser() {
        if let email = Auth.auth().currentUser?.email {
            OneSignal.setEmail(email)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd,yyyy"
        var date = dateFormatter.string(from: Date())
        if UserDefaults.standard.string(forKey: K.defaults.referred) != "" && UserDefaults.standard.string(forKey: K.defaults.referred) != nil  {
            // create user session
            let newDate = Calendar.current.date(byAdding: .weekOfMonth, value: 2, to: Date())
            date = dateFormatter.string(from: newDate ?? Date())
        }
        if let referredEmail = UserDefaults.standard.string(forKey: K.defaults.referred) {
            if referredEmail != "" {
                var refDate = ""
                var refStack = 0
                //update referred stack for user that referred
                db.collection(K.userPreferences).document(referredEmail).getDocument { [self] (snapshot, error) in
                    if let document = snapshot, document.exists {
                        if let stack = document["referredStack"] as? String {
                            let plusIndex = stack.indexInt(of: "+") ?? 0
                            refDate = stack.substring(to: plusIndex)
                            refStack = Int(stack.substring(from: plusIndex + 1)) ?? 0
                        }
                        var dte = dateFormatter.date(from: refDate == "" ? dateFormatter.string(from: Date()) : refDate)
                        if dte ?? Date() < Date() {
                            dte = Date()
                        }
                        let newDate = Calendar.current.date(byAdding: .weekOfMonth, value: 2, to: dte ?? Date())
                        let newDateString = dateFormatter.string(from: newDate ?? Date())
                        refStack += 1
                        let referredStack = newDateString+"+"+String(refStack)
                        db.collection(K.userPreferences).document(referredEmail)
                            .updateData([
                                "referredStack": referredStack
                        ])
                    }
                }

//                var dte = dateFormatter.date(from: refDate == "" ? dateFormatter.string(from: Date()) : refDate)
//                if dte ?? Date() < Date() {
//                    dte = Date()
//                }
//                let newDate = Calendar.current.date(byAdding: .weekOfMonth, value: 2, to: dte ?? Date())
//                let newDateString = dateFormatter.string(from: newDate ?? Date())
//                refStack += 1
//                let referredStack = newDateString+"+"+String(refStack)
//                db.collection(K.userPreferences).document(referredEmail)
//                    .updateData([
//                        "referredStack": referredStack
//                ])
            }
        }
        var thisGrid = [String: [String:[String:[String:Any]]]]()
        if let gridd = UserDefaults.standard.value(forKey: "grid") as? [String: [String:[String:[String:Any]]]] {
            thisGrid = gridd
        }
        var favs = [Int]()
        if let favorites = UserDefaults.standard.array(forKey: K.defaults.favorites) as? [Int] {
            favs = favorites
        }

        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).setData([
                "name": UserDefaults.standard.string(forKey: "name") ?? "hg", 
                "coins": UserDefaults.standard.integer(forKey: "coins"),
                "joinDate": UserDefaults.standard.string(forKey: "joinDate") ?? "",
                "totalSessions": UserDefaults.standard.integer(forKey: "allTimeSessions"),
                "totalMins": UserDefaults.standard.integer(forKey: "allTimeMinutes"),
                "gardenGrid": thisGrid,
                "plants": UserDefaults.standard.array(forKey: K.defaults.plants) ?? ["White Daisy"],
                K.defaults.lastStreakDate: UserDefaults.standard.string(forKey: K.defaults.lastStreakDate) ?? "",
                "streak": UserDefaults.standard.string(forKey: "streak") ?? "",
                K.defaults.seven: UserDefaults.standard.integer(forKey: K.defaults.seven),
                K.defaults.thirty: UserDefaults.standard.integer(forKey: K.defaults.thirty),
                K.defaults.dailyBonus: UserDefaults.standard.string(forKey: K.defaults.dailyBonus) ?? "", 
                "referredStack": "\(date)+0",
                "isPro": UserDefaults.standard.bool(forKey: "isPro"),
                "favorited": favs
            ]) { (error) in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    UserDefaults.standard.setValue("White Daisy", forKey: K.defaults.selectedPlant)
                    UserDefaults.standard.setValue("nature", forKey: "sound")
                    self.userModel.getSelectedPlant()
                }
            }
        }
        userModel.name = UserDefaults.standard.string(forKey: "name") ?? "hg"
        userModel.joinDate = formatter.string(from: Date())
        userModel.referredStack = "\(date)+0"
        userModel.checkIfPro()
    }

    func getData() {
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    if let name = document[K.defaults.name] {
                        UserDefaults.standard.setValue(name, forKey: K.defaults.name)
                    }
                    if let joinDate = document[K.defaults.joinDate] {
                        UserDefaults.standard.setValue(joinDate, forKey: K.defaults.joinDate)
                    }
                    if let isPro = document["isPro"] {
                        UserDefaults.standard.setValue(isPro, forKey: "isPro")
                    }
                }
            }
        }
    }
}

extension AuthenticationViewModel {
    //Hashing function using CryptoKit
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }
}

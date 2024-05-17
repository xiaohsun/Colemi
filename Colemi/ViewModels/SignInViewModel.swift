//
//  SignInViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/7/24.
//

import Foundation
import Firebase
import FirebaseAuth

class SignInViewModel {
    
    let userData = UserManager.shared
    let firestoreManager = FirestoreManager.shared
    var isCreatedOnce: Bool = false
    let dateFormatter = DateFormatter()
    
    func createUser() {
        
        // let docRef = firestoreManager.newDocument(of: FirestoreEndpoint.users.ref)
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        isCreatedOnce = true
        
        let user = User(id: userID,
                        name: "你是誰",
                        posts: [],
                        likes: [],
                        avatarPhoto: "",
                        description: "",
                        savedPosts: [],
                        signUpTime: Timestamp(),
                        lastestLoginTime: Timestamp(),
                        colorToday: "",
                        colorSetToday: [],
                        mixColorToday: "",
                        postToday: "",
                        chatRooms: [],
                        followers: [],
                        following: [],
                        blocking: [],
                        beBlocked: [],
                        status: 1,
                        colorPoints: 0,
                        collectedColors: []
        )
        
        do {
            try Firestore.firestore().collection("users").document(userID).setData(from: user) { _ in
                self.loginUser()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loginUser() {
        Task {
            await getUserData { [weak self] user in
                guard let self = self else { return }
                if let user = user {
                    DispatchQueue.main.async {
                        self.userData.avatarPhoto = user.avatarPhoto
                        self.userData.chatRooms = user.chatRooms
                        self.userData.description = user.description
                        self.userData.followers = user.followers
                        self.userData.following = user.following
                        self.userData.id = user.id
                        self.userData.lastestLoginTime = user.lastestLoginTime
                        self.userData.likes = user.likes
                        self.userData.name = user.name
                        self.userData.colorToday = user.colorToday
                        self.userData.colorSetToday = user.colorSetToday
                        self.userData.mixColorToday = user.mixColorToday
                        self.userData.postToday = user.postToday
                        self.userData.savedPosts = user.savedPosts
                        self.userData.signUpTime = user.signUpTime
                        self.userData.posts = user.posts
                        self.userData.blocking = user.blocking
                        self.userData.beBlocked = user.beBlocked
                        self.userData.status = user.status
                        self.userData.colorPoints = user.colorPoints
                        self.userData.collectedColors = user.collectedColors
                        print(self.userData.name)
                        
                        self.seeIfLastLoginTimeToday()
                    }
                } else {
                    if !isCreatedOnce {
                        createUser()
                    }
                }
            }
        }
    }
    
    func getUserData(completion: @escaping (User?) -> Void) async {
        if let userID = Auth.auth().currentUser?.uid {
            let ref = FirestoreEndpoint.users.ref
            let userData: User? = await firestoreManager.getSpecificDocument(collection: ref, docID: userID)
            
            completion(userData)
        }
    }
    
    // 在選完顏色後再改登入時間
    func updateLoginTime() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let ref = FirestoreEndpoint.users.ref
        
        firestoreManager.updateDocument(data: [UserProperty.lastestLoginTime.rawValue: Timestamp()], collection: ref, docID: userID)
    }
    
    func seeIfLastLoginTimeToday() {
        let lastestLoginTime = userData.lastestLoginTime.dateValue()
        
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dateFormatter.timeZone = TimeZone.current
//        let localTimeString = dateFormatter.string(from: lastestLoginTime)
//        print(localTimeString)
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        // if let date = dateFormatter.date(from: localTimeString) {
//        if let lastestLoginTime {
//            print(date)
            if isToday(date: lastestLoginTime) {
                if isCreatedOnce {
                    setRootVCToChooseColor()
                } else {
                    updateLoginTime()
                    setRootVCToTabBarController()
                }
                
            } else {
                setRootVCToChooseColor()
            }
//        } else {
//            print("Can't read lastLoginTime")
//        }
    }
    
//    func isToday(date: Date) -> Bool {
//        let calendar = Calendar.current
//        return calendar.isDateInToday(date)
//    }
    
    func isToday(date: Date) -> Bool {
        
        let todayDateString = dateFormatter.string(from: Date())
        let dateString = dateFormatter.string(from: date)
        
        return dateString == todayDateString
    }
    
    func setRootVCToChooseColor() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
            
        let chooseColorVC = ChooseColorViewController()
        
        UIView.transition(with: sceneDelegate.window!,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
            sceneDelegate.window?.rootViewController = chooseColorVC
        })
    }
    
    func setRootVCToTabBarController() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
            
        let tabBarController = TabBarController()
        
        UIView.transition(with: sceneDelegate.window!,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
            sceneDelegate.window?.rootViewController = tabBarController
        })
    }
}

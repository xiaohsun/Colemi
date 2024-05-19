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
    var isNewbie: Bool = false
    let dateFormatter = DateFormatter()
    
    func createUser() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        isNewbie = true
        
        let user = User(id: userID,
                        name: "你是誰",
                        posts: [],
                        likes: [],
                        avatarPhoto: "",
                        description: "",
                        savedPosts: [],
                        signUpTime: Timestamp(),
                        lastestLoginTime: nil,
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
                        collectedColors: [])
        
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
                        
                        if !self.isNewbie {
                            self.seeIfLastLoginTimeToday()
                        } else {
                            self.goToAnotherPage(isSameDay: true)
                        }
                    }
                } else {
                        createUser()
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
    
    private func updateLoginTime() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let ref = FirestoreEndpoint.users.ref
        
        firestoreManager.updateDocument(data: [UserProperty.lastestLoginTime.rawValue: Timestamp()], collection: ref, docID: userID)
    }
    
    private func clearLastDayData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let ref = FirestoreEndpoint.users.ref
        
        let updateData: [String: Any] = [
            UserProperty.colorToday.rawValue: "",
            UserProperty.colorSetToday.rawValue: [] as [String],
            UserProperty.mixColorToday.rawValue: "",
            UserProperty.postToday.rawValue: ""
        ]
        
        firestoreManager.updateMutipleDocument(data: updateData, collection: ref, docID: userID)
    }
    
    private func seeIfLastLoginTimeToday() {
        guard let lastestLoginTime = userData.lastestLoginTime?.dateValue() else {
            setRootVCToChooseColor()
            return
        }
        
        let timeNow = Date()
        let calendar = Calendar.current
        
        let lastestLoginTimeComponents = calendar.dateComponents([.year, .month, .day], from: lastestLoginTime)
        let timeNowComponents = calendar.dateComponents([.year, .month, .day], from: timeNow)
        
        let isSameDay = (lastestLoginTimeComponents.year == timeNowComponents.year) &&
        (lastestLoginTimeComponents.month == timeNowComponents.month) &&
        (lastestLoginTimeComponents.day == timeNowComponents.day)
        
        goToAnotherPage(isSameDay: isSameDay)
    }
    
    private func goToAnotherPage(isSameDay: Bool) {
        if isNewbie {
            setRootVCToTutor()
        } else if !isNewbie && isSameDay {
            updateLoginTime()
            setRootVCToTabBarController()
        } else if !isNewbie && !isSameDay {
            clearLastDayData()
            setRootVCToChooseColor()
        }
    }
    
    func setRootVCToChooseColor() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        
        let chooseColorVC = ChooseColorViewController()
        
        UIView.transition(with: sceneDelegate.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            sceneDelegate.window?.rootViewController = chooseColorVC
        })
    }
    
    func setRootVCToTutor() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        
        let tutorViewController = TutorViewController()
        
        UIView.transition(with: sceneDelegate.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            sceneDelegate.window?.rootViewController = tutorViewController
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

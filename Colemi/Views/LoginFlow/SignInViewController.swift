//
//  SignInViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/30/24.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import AuthenticationServices
import CryptoKit
import GoogleSignIn

class SignInViewController: UIViewController {
    
    let signInViewModel = SignInViewModel()
    var agreeEULA: Bool = false
    let containerViewColors = [UIColor(hex: "#EF8E83"), UIColor(hex: "#FFEA63"), UIColor(hex: "#577D41")]
    var containerViews: [UIView] = []
    
    lazy var chooseLoginMethodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "選擇登入方式"
        label.font = ThemeFontProperty.GenSenRoundedTW_B.getFont(size: 30)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        
        return label
    }()
    
    lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "circle")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = ThemeColorProperty.darkColor.getColor()
        imageView.contentMode = .scaleAspectFit
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showEULAPage))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true

        return imageView
    }()
    
    lazy var squareGreenView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#B7CC9A")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var squareBlueView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#97B9F2")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var EULAButton: UIButton = {
        let button = UIButton()
        button.setTitle("使用者條款", for: .normal)
        button.setTitleColor(ThemeColorProperty.darkColor.getColor(), for: .normal)
        button.titleLabel?.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 16)
        button.addTarget(self, action: #selector(showEULAPage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var goWithoutSignIn: UIButton = {
        let button = UIButton()
        button.setImage(.touristIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(goWithoutSignInTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func goWithoutSignInTapped() {
        signInViewModel.setRootVCToTabBarController()
    }
    
    @objc func showEULAPage() {
        let eulaPopUp = EULAPopUp()
        eulaPopUp.delegate = self
        eulaPopUp.fromSignInPage = true
        eulaPopUp.appear(sender: self)
    }
    
    private func createContainerView(withBackgroundColor color: UIColor) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        return view
    }
    
    private func setUpUI() {
        view.addSubview(squareBlueView)
        view.addSubview(squareGreenView)
        
        for color in containerViewColors {
            let containerView = createContainerView(withBackgroundColor: color ?? .white)
            view.addSubview(containerView)
            containerViews.append(containerView)
        }
        
        view.addSubview(chooseLoginMethodLabel)
        view.addSubview(checkImageView)
        view.addSubview(EULAButton)
        view.addSubview(signInWithGoogleBtn)
        view.addSubview(signInWithAppleBtn)
        view.addSubview(goWithoutSignIn)
        
        NSLayoutConstraint.activate([
            
            squareBlueView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.1),
            squareBlueView.heightAnchor.constraint(equalTo: squareBlueView.widthAnchor, multiplier: 0.7),
            squareBlueView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),
            squareBlueView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            
            squareGreenView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.1),
            squareGreenView.heightAnchor.constraint(equalTo: squareGreenView.widthAnchor, multiplier: 0.4),
            squareGreenView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -80),
            squareGreenView.centerYAnchor.constraint(equalTo: squareBlueView.centerYAnchor, constant: 120),
            
            chooseLoginMethodLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chooseLoginMethodLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            
            checkImageView.widthAnchor.constraint(equalToConstant: 20),
            checkImageView.heightAnchor.constraint(equalTo: checkImageView.widthAnchor),
            checkImageView.trailingAnchor.constraint(equalTo: EULAButton.leadingAnchor, constant: -10),
            checkImageView.centerYAnchor.constraint(equalTo: EULAButton.centerYAnchor),
            
            EULAButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            EULAButton.topAnchor.constraint(equalTo: chooseLoginMethodLabel.bottomAnchor, constant: 20),
            
            containerViews[0].heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            containerViews[0].widthAnchor.constraint(equalTo: containerViews[0].heightAnchor),
            containerViews[0].centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerViews[0].topAnchor.constraint(equalTo: EULAButton.bottomAnchor, constant: 60),
            
            signInWithGoogleBtn.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15),
            signInWithGoogleBtn.widthAnchor.constraint(equalTo: signInWithGoogleBtn.heightAnchor),
            signInWithGoogleBtn.centerXAnchor.constraint(equalTo: containerViews[0].centerXAnchor),
            signInWithGoogleBtn.centerYAnchor.constraint(equalTo: containerViews[0].centerYAnchor),
            
            containerViews[1].heightAnchor.constraint(equalTo: containerViews[0].widthAnchor),
            containerViews[1].widthAnchor.constraint(equalTo: containerViews[0].widthAnchor),
            containerViews[1].centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 60),
            containerViews[1].topAnchor.constraint(equalTo: containerViews[0].bottomAnchor, constant: 50),
            
            signInWithAppleBtn.heightAnchor.constraint(equalTo: signInWithGoogleBtn.widthAnchor),
            signInWithAppleBtn.widthAnchor.constraint(equalTo: signInWithGoogleBtn.heightAnchor),
            signInWithAppleBtn.centerXAnchor.constraint(equalTo: containerViews[1].centerXAnchor),
            signInWithAppleBtn.centerYAnchor.constraint(equalTo: containerViews[1].centerYAnchor),
            
            containerViews[2].heightAnchor.constraint(equalTo: containerViews[0].widthAnchor),
            containerViews[2].widthAnchor.constraint(equalTo: containerViews[0].widthAnchor),
            containerViews[2].centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            containerViews[2].topAnchor.constraint(equalTo: containerViews[1].bottomAnchor, constant: 50),
            
            goWithoutSignIn.heightAnchor.constraint(equalTo: signInWithGoogleBtn.widthAnchor),
            goWithoutSignIn.widthAnchor.constraint(equalTo: signInWithGoogleBtn.heightAnchor),
            goWithoutSignIn.centerXAnchor.constraint(equalTo: containerViews[2].centerXAnchor),
            goWithoutSignIn.centerYAnchor.constraint(equalTo: containerViews[2].centerYAnchor)
        ])
        
        view.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        setUpUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        checkImageView.layer.cornerRadius = checkImageView.frame.width / 2
        for view in containerViews {
            view.layer.cornerRadius = view.frame.width / 2
        }
        squareGreenView.layer.cornerRadius = squareGreenView.frame.width / 8
        squareBlueView.layer.cornerRadius = squareBlueView.frame.width / 3
        
        squareGreenView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 60 / 180)
        squareBlueView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi * 45 / 180)
        
        // squareGreenView.transform = .init(rotationAngle: 73)
        // squareBlueView.transform = .init(rotationAngle: 100)

    }
    
    // MARK: - Sign in with Google
    
    lazy var signInWithGoogleBtn: UIButton = {
        let button = UIButton()
        button.setImage(.googleIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signInWithGoogleBtnTapped), for: .touchUpInside)
       
        return button
    }()
    
    @objc private func signInWithGoogleBtnTapped() {
        if !agreeEULA {
            showEULAAlert()
        } else {
            signInWithGoogle()
            signInWithGoogleBtn.isEnabled = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.signInWithGoogleBtn.isEnabled = true
            }
        }
    }
    
    private func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            
            guard error == nil else {
                CustomFunc.customAlert(title: "", message: "\(String(describing: error!.localizedDescription))", vc: self, actionHandler: nil)
                return
            }
            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                             accessToken: user.accessToken.tokenString)
            
            self.firebaseSignInWithGoogle(credential: credential)
        }
    }

    private func firebaseSignInWithGoogle(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { _, error in
            guard error == nil else {
                CustomFunc.customAlert(title: "", message: "\(String(describing: error!.localizedDescription))", vc: self, actionHandler: nil)
                return
            }
            CustomFunc.customAlert(title: "登入成功！", message: "", vc: self) {
                // self.changeRootVC()
                self.signInViewModel.loginUser()
            }
        }
    }
    
    
    // MARK: - Sign in with Apple
    
    lazy var signInWithAppleBtn: UIButton = {
        let button = UIButton()
        button.setImage(.appleIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//    private func chooseAppleButtonStyle() -> ASAuthorizationAppleIDButton.Style {
//        return (UITraitCollection.current.userInterfaceStyle == .light) ? .black : .white
//    }
    
    fileprivate var currentNonce: String?
    
    @objc private func signInWithApple() {
        if !agreeEULA {
            showEULAAlert()
        } else {
            signInWithAppleBtn.isEnabled = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.signInWithAppleBtn.isEnabled = true
            }
            
            let nonce = randomNonceString()
            currentNonce = nonce
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while(remainingLength > 0) {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if (errorCode != errSecSuccess) {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if (remainingLength == 0) {
                    return
                }
                
                if (random < charset.count) {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
}

extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        // 登入成功
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                CustomFunc.customAlert(title: "", message: "Unable to fetch identity token", vc: self, actionHandler: nil)
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                CustomFunc.customAlert(title: "", message: "Unable to serialize token string from data\n\(appleIDToken.debugDescription)", vc: self, actionHandler: nil)
                return
            }
            // 產生 Apple ID 登入的 Credential
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            // 與 Firebase Auth 進行串接
            firebaseSignInWithApple(credential: credential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 登入失敗，處理 Error
        switch error {
        case ASAuthorizationError.canceled:
            CustomFunc.customAlert(title: "使用者取消登入", message: "", vc: self, actionHandler: nil)
        case ASAuthorizationError.failed:
            CustomFunc.customAlert(title: "授權請求失敗", message: "", vc: self, actionHandler: nil)
        case ASAuthorizationError.invalidResponse:
            CustomFunc.customAlert(title: "授權請求無回應", message: "", vc: self, actionHandler: nil)
        case ASAuthorizationError.notHandled:
            CustomFunc.customAlert(title: "授權請求未處理", message: "", vc: self, actionHandler: nil)
        case ASAuthorizationError.unknown:
            CustomFunc.customAlert(title: "授權失敗，原因不知", message: "", vc: self, actionHandler: nil)
        default:
            break
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
// 在畫面上顯示授權畫面
extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

extension SignInViewController {
    // MARK: - 透過 Credential 與 Firebase Auth 串接
    func firebaseSignInWithApple(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { _, error in
            guard error == nil else {
                CustomFunc.customAlert(title: "", message: "\(String(describing: error!.localizedDescription))", vc: self, actionHandler: nil)
                return
            }
            
            CustomFunc.customAlert(title: "登入成功！", message: "", vc: self) {
                self.signInViewModel.loginUser()
            }
        }
    }
    
    // MARK: - Firebase 取得登入使用者的資訊
    func getFirebaseUserInfo() {
        let currentUser = Auth.auth().currentUser
        guard let user = currentUser else {
            CustomFunc.customAlert(title: "無法取得使用者資料！", message: "", vc: self, actionHandler: nil)
            return
        }
        let uid = user.uid
        let email = user.email
        CustomFunc.customAlert(title: "使用者資訊", message: "UID：\(uid)\nEmail：\(email!)", vc: self, actionHandler: nil)
    }
    
//    func changeRootVC() {
//        signInViewModel.loginUser()
//        
//        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
//            return
//        }
//            
//        let tabBarController = TabBarController()
//        
//        UIView.transition(with: sceneDelegate.window!,
//                          duration: 0.3,
//                          options: .transitionCrossDissolve,
//                          animations: {
//            sceneDelegate.window?.rootViewController = tabBarController
//        })
//    }
    
    // MARK: - 監聽目前的 Apple ID 的登入狀況
    // 主動監聽
    func checkAppleIDCredentialState(userID: String) {
        ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID) { credentialState, _ in
            switch credentialState {
            case .authorized:
                CustomFunc.customAlert(title: "使用者已授權！", message: "", vc: self, actionHandler: nil)
            case .revoked:
                CustomFunc.customAlert(title: "使用者憑證已被註銷！", message: "請到\n「設定 → Apple ID → 密碼與安全性 → 使用 Apple ID 的 App」\n將此 App 停止使用 Apple ID\n並再次使用 Apple ID 登入本 App！", vc: self, actionHandler: nil)
            case .notFound:
                CustomFunc.customAlert(title: "", message: "使用者尚未使用過 Apple ID 登入！", vc: self, actionHandler: nil)
            case .transferred:
                CustomFunc.customAlert(title: "請與開發者團隊進行聯繫，以利進行使用者遷移！", message: "", vc: self, actionHandler: nil)
            default:
                break
            }
        }
    }
    
    func observeAppleIDState() {
        NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil, queue: nil) { (_: Notification) in
            CustomFunc.customAlert(title: "使用者登入或登出", message: "", vc: self, actionHandler: nil)
        }
    }
}

class CustomFunc {
    class func customAlert(title: String, message: String, vc: UIViewController, actionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "關閉", style: .default) { _ in
            actionHandler?()
        }
        alertController.addAction(closeAction)
        vc.present(alertController, animated: true)
    }
    
    class func needLoginAlert(title: String, message: String, vc: UIViewController, actionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "關閉", style: .default) { _ in
            actionHandler?()
        }
        let signInAction = UIAlertAction(title: "登入", style: .default) { _ in
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                return
            }
            let loggedInViewController = SignInViewController()
            sceneDelegate.window?.rootViewController = loggedInViewController
        }
        alertController.addAction(closeAction)
        alertController.addAction(signInAction)
        vc.present(alertController, animated: true)
    }
    
    class func getSystemTime() -> String {
        let currectDate = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale.ReferenceType.system
        dateFormatter.timeZone = TimeZone.ReferenceType.system
        return dateFormatter.string(from: currectDate)
    }
}

extension SignInViewController: EULAPopUpDelegate {
    func eulaAgreeTapped() {
        agreeEULA = true
        
        checkImageView.image = UIImage(systemName: "checkmark.circle")?.withRenderingMode(.alwaysTemplate)
        checkImageView.tintColor = ThemeColorProperty.darkColor.getColor()
        checkImageView.layoutIfNeeded()
    }
}

extension SignInViewController {
    func showEULAAlert() {
        CustomFunc.customAlert(title: "請同意使用者條款", message: "您必須同意使用者條款才能註冊並使用 Colemi", vc: self, actionHandler: nil)
    }
}
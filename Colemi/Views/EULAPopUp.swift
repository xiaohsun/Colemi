//
//  EULAPopUp.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/10/24.
//

import UIKit

class EULAPopUp: UIViewController {
    
    var containerViewTopCons: NSLayoutConstraint?
    var containerViewYCons: NSLayoutConstraint?
    weak var delegate: EULAPopUpDelegate?
    var fromSignInPage: Bool = false
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = RadiusProperty.radiusTwenty.rawValue
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        return scrollView
    }()
    
    lazy var eulaContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 10)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.text = """
        使用者條款（EULA）：
        
        於您註冊 Colemi 服務的帳號前，請您先完整閱讀並確認您同意本協議的全部內容，如有任何不同意之處，請您切勿使用 Colemi 服務；當您完成 Colemi 會員註冊程序，作為 Colemi 服務的使用者時，代表您已瞭解且同意遵守本協議下示條款。若您違反相關以下任一規定，Colemi 有權以我方之判斷做出適當的處置，您同意完全遵循 Colemi 之決定。

        * 關於您在使用 Colemi 服務時發佈的文章和其他內容（以下統稱為「使用者內容」），您對相關的智慧財產權享有法律上的權利。然而，就這些使用者內容及相關的智慧財產權，您同意以下事項：
        1. 您永久且非獨家地授予 Colemi 全球範圍內的轉讓、轉授權、無償的使用權，使Colemi可以根據此授權重製或以其他方式使用使用者內容的全部或部分。您聲明並保證您擁有足夠的權利或授權，可以有效地將前述授權授予 Colemi。
        2. Colemi 保留拒絕接受、張貼、顯示或傳輸使用者內容的權利，並且有權根據由Colemi制定的管理使用者行為和使用者內容的規定刪除您發佈的使用者內容。
        3. 若使用者內容被刪除，Colemi 有權留存備份，但 Colemi 並無備份之義務。

        * 使用者內容不得包含下述資訊：
        1. 含有引誘、媒介、暗示或其他方式促使人進行性交易的訊息。
        2. 包含兒童或少年性行為、猥褻行為等圖畫、照片、影片或相關物品。
        3. 含有引誘、媒介、暗示或其他方式使兒童或少年有遭受兒童及少年性剝削防制條例第 2 條第 1 項第 1 款至第 3 款所規定之虞的訊息。
        4. 發布之內容與兒童或青少年涉刑事案件相關，且記載相關當事人之姓名或其他足以識別其身份之資訊。
        5. 內容與涉及兒童或青少年的刑事案件相關，且記載了相關當事人的姓名或其他足以識別其身份的資訊。
        6. 侵害他人智慧財產權、肖像權、隱私權或其他權利的內容。
        7. 違反本協議或鼓勵他人違反本協議的內容。
        8. 違反法律強制或禁止規定的內容。
        9. 違反公共秩序或社會善良風俗的內容。
        10. 其他由Colemi認定應刪除的內容。
                
        * 使用者行為限制，您同意不得為下列行為：
        1. 破解或以任何方式繞過Colemi用於防止或限制服務全部或部分使用的措施，或試圖使用任何方式來獲取任何 Colemi 服務、其網站或相關程式的原始碼或程式碼。
        2. 進行任何形式的騷擾、猥褻、威脅、詐欺、霸凌、侵犯 Colemi 或他人權益，或濫用 Colemi 服務的行為。
        3. 進行任何違反法律、本協議、公共秩序或善良風俗的行為，或其他經 Colemi 通知您停止的行為。

        * 檢舉及申訴，您同意 Colemi 可以針對使用者違反本協議之行為，按下述機制處置：
        1. 如果有任何人根據檢舉機制向 Colemi 檢舉您的使用者內容違反本協議或符合刪除規則等規定，Colemi在收到檢舉後，可依據自身裁量進行審查，確定違反規定後，依相關規定直接刪除您的使用者內容，或根據情況暫時或永久停止您的權限。
        2. 如有任何人依據申訴機制向 Colemi 申訴您的使用者內容侵害其個人權利，Colemi 不需經您的同意，即得先行將您的使用者內容取下，待您與權利人之間的紛爭解決，Colemi 始能回復您的使用者內容。
        
        * 天氣資料
        Colemi 會使用您所在位置的天氣資料，資料來源為  Weather：
        https://weatherkit.apple.com/legal-attribution.html
        """
        
        return label
    }()
    
    lazy var agreedButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ThemeColorProperty.lightColor.getColor(), for: .normal)
        button.setTitle("我同意", for: .normal)
        button.titleLabel?.font = ThemeFontProperty.GenSenRoundedTW_H.getFont(size: 14)
        button.backgroundColor = ThemeColorProperty.darkColor.getColor()
        button.addTarget(self, action: #selector(agreedBtnTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        return button
    }()
    
    @objc private func agreedBtnTapped() {
        delegate?.eulaAgreeTapped()
        hide()
    }
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(dismissPopUp), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func dismissPopUp() {
        hide()
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        containerView.addSubview(closeButton)
        containerView.addSubview(scrollView)
        scrollView.addSubview(eulaContentLabel)
        
        if fromSignInPage {
            containerView.addSubview(agreedButton)
            
            NSLayoutConstraint.activate([
                agreedButton.heightAnchor.constraint(equalToConstant: 50),
                agreedButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
                agreedButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
                agreedButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15)
            ])
        }
        
        containerViewTopCons = containerView.topAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewTopCons?.isActive = true
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            closeButton.widthAnchor.constraint(equalToConstant: 10),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            scrollView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            scrollView.bottomAnchor.constraint(equalTo: (fromSignInPage ? agreedButton.topAnchor : containerView.bottomAnchor), constant: -10),
            
            eulaContentLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            eulaContentLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            eulaContentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        eulaContentLabel.addLineSpacing()
        scrollView.contentSize = CGSize(width: eulaContentLabel.frame.width, height: eulaContentLabel.frame.height + 50)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        backgroundAddGesture()
    }
    
    private func backgroundAddGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        backgroundView.addGestureRecognizer(tapGesture)
        backgroundView.isUserInteractionEnabled = true
    }
    
    func appear(sender: UIViewController) {
        self.modalPresentationStyle = .overFullScreen
        sender.present(self, animated: false) {
            self.containerViewTopCons?.isActive = false
            self.containerViewYCons = self.containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            self.containerViewYCons?.isActive = true
            UIView.animate(withDuration: 0.2) {
                self.backgroundView.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func hide() {
        self.containerViewTopCons?.constant = 0
        self.containerViewYCons?.constant = 1000
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.backgroundView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }
}

protocol EULAPopUpDelegate: AnyObject {
    func eulaAgreeTapped()
}

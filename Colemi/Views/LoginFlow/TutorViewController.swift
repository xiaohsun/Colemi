//
//  TutorViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/19/24.
//

import UIKit

class TutorViewController: UIViewController {
    
    private lazy var chooseColorTutorVC = ChooseColorTutorVC()
    private lazy var mixColorTutorVC = MixColorTutorVC()
    private lazy var postsTutorVC = PostsTutorVC()
    private lazy var colorPointsTutorVC = ColorPointsTutorVC()
    private lazy var wallTutorVC = WallTutorVC()
    var circularButtons: [UIButton] = []
    var currentPage: Int = 0
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = ThemeColorProperty.darkColor.getColor()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = TutorTitleProperty.zero.getTitle()
        label.font = ThemeFontProperty.GenSenRoundedTW_B.getFont(size: 38)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = TutorContentProperty.zero.getContent()
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 20)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.addLineSpacing(lineSpacing: 8)
        return label
    }()
    
    lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.arrowIcon
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(arrowTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    @objc private func arrowTapped() {
        if currentPage < circularButtons.count - 1 {
            currentPage += 1
            circularButtonTapped(sender: circularButtons[currentPage])
        } else if currentPage == circularButtons.count - 1 {
            setRootVCToChooseColor()
        }
    }
    
    private func setRootVCToChooseColor() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        
        let chooseColorVC = ChooseColorViewController()
        
        UIView.transition(with: sceneDelegate.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            sceneDelegate.window?.rootViewController = chooseColorVC
        })
    }
    
    func createCircularButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = ThemeColorProperty.darkColor.getColor().withAlphaComponent(0.3)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(circularButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ThemeColorProperty.darkColor.getColor()
        return button
    }
    
    @objc private func circularButtonTapped(sender: UIButton) {
        for btn in circularButtons {
            btn.backgroundColor = ThemeColorProperty.darkColor.getColor().withAlphaComponent(0.3)
        }
        sender.backgroundColor = ThemeColorProperty.darkColor.getColor()
        currentPage = sender.tag
        titleLabel.text = TutorTitleProperty(rawValue: currentPage)?.getTitle()
        contentLabel.text = TutorContentProperty(rawValue: currentPage)?.getContent()
        
        switch sender.tag {
        case 0:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        case 1:
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: true)
        case 2:
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width * 2, y: 0), animated: true)
        case 3:
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width * 3, y: 0), animated: true)
        case 4:
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width * 4, y: 0), animated: true)
        default:
            print("NONE")
        }
    }
    
    private func addChildVCs() {
        addChild(chooseColorTutorVC)
        addChild(mixColorTutorVC)
        addChild(postsTutorVC)
        addChild(colorPointsTutorVC)
        addChild(wallTutorVC)
        
        for (index, childVC) in children.enumerated() {
            childVC.view.frame = CGRect(x: CGFloat(index) * scrollView.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            scrollView.addSubview(childVC.view)
            
            childVC.didMove(toParent: self)
        }
    }
    
    private func layoutCircularButtons() {
        var previousBtn: UIButton?
        
        for btn in circularButtons {
            view.addSubview(btn)
            NSLayoutConstraint.activate([
                btn.leadingAnchor.constraint(
                    equalTo: previousBtn?.trailingAnchor ?? view.leadingAnchor, constant: (previousBtn == nil) ? 30 : 10),
                btn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
                btn.widthAnchor.constraint(equalToConstant: 10),
                btn.heightAnchor.constraint(equalTo: btn.widthAnchor)
            ])
            previousBtn = btn
        }
    }
    
    private func setUpUI() {
        for index in 0..<5 {
            let btn = createCircularButton()
            circularButtons.append(btn)
            btn.tag = index
        }
        
        view.addSubview(scrollView)
        view.addSubview(bottomView)
        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
        view.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            titleLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            arrowImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.08),
            arrowImageView.heightAnchor.constraint(equalTo: arrowImageView.widthAnchor),
            arrowImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            arrowImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45)
        ])
        
        layoutCircularButtons()
        addChildVCs()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(children.count), height: scrollView.bounds.height)
        circularButtonTapped(sender: circularButtons[0])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for btn in circularButtons {
            btn.layer.cornerRadius = btn.frame.width / 2
        }
    }
}

// MARK: - UIScrollViewDelegate

extension TutorViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 5) / pageWidth)
        circularButtonTapped(sender: circularButtons[currentPage])
    }
}

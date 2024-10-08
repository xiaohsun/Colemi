//
//  ViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/10/24.
//

import UIKit
import Kingfisher

enum LobbyButtonProperty: String {
    case allColor = "全部顏色"
    case todayColor = "今日顏色"
    case mixColor = "今日混色"
}

class LobbyViewController: UIViewController {
    
    var currentIndex: Int = 0
    var buttons: [UIButton] = []
    var bottomLabels: [UILabel] = []
    var buttonWidth: CGFloat = 80
    var buttonHeight: CGFloat = 25
    
    private lazy var allColorChild = AllColorViewController()
    private lazy var todayColorChild = TodayColorViewController()
    private lazy var mixColorChild = MixColorViewController()
    
    lazy var buttonOne = createButton()
    lazy var buttonTwo = createButton()
    lazy var buttonThree = createButton()
    
    func createButton() -> UIButton {
        let button = UIButton()
        button.titleLabel?.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 18)
        button.setTitleColor(ThemeColorProperty.darkColor.getColor(), for: .selected)
        button.setTitleColor(.lightGray, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func makeBottomLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "滑到底囉～！"
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 18)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        
        return label
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        for button in buttons {
            button.isSelected = false
        }
        
        switch sender {
        case buttonOne:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            buttonOne.isSelected = true
        case buttonTwo:
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: true)
            buttonTwo.isSelected = true
        case buttonThree:
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width * 2, y: 0), animated: true)
            buttonThree.isSelected = true
        default:
            break
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        return scrollView
    }()
    
    private func addChildVCs() {
        addChild(allColorChild)
        addChild(todayColorChild)
        addChild(mixColorChild)
        
        for (index, childVC) in children.enumerated() {
            childVC.view.frame = CGRect(x: CGFloat(index) * scrollView.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            bottomLabels.append(makeBottomLabel())
            scrollView.addSubview(childVC.view)
            
            if index != 1 {
                scrollView.addSubview(bottomLabels[index])
                NSLayoutConstraint.activate([
                    bottomLabels[index].topAnchor.constraint(equalTo: childVC.view.bottomAnchor, constant: 80),
                    bottomLabels[index].centerXAnchor.constraint(equalTo: childVC.view.centerXAnchor)
                ])
            }
            
            childVC.didMove(toParent: self)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(buttonOne)
        view.addSubview(buttonTwo)
        view.addSubview(buttonThree)
        view.addSubview(scrollView)
        
        buttons.append(buttonOne)
        buttons.append(buttonTwo)
        buttons.append(buttonThree)
        
        buttonOne.setTitle(LobbyButtonProperty.allColor.rawValue, for: .normal)
        buttonTwo.setTitle(LobbyButtonProperty.todayColor.rawValue, for: .normal)
        buttonThree.setTitle(LobbyButtonProperty.mixColor.rawValue, for: .normal)
        
        buttonOne.isSelected = true
        
        NSLayoutConstraint.activate([
            
            buttonOne.widthAnchor.constraint(equalToConstant: buttonWidth),
            buttonOne.heightAnchor.constraint(equalToConstant: buttonHeight),
            buttonOne.trailingAnchor.constraint(equalTo: buttonTwo.leadingAnchor, constant: -35),
            buttonOne.topAnchor.constraint(equalTo: buttonTwo.topAnchor),
            
            buttonTwo.widthAnchor.constraint(equalToConstant: buttonWidth),
            buttonTwo.heightAnchor.constraint(equalToConstant: buttonHeight),
            buttonTwo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonTwo.topAnchor.constraint(equalTo: view.topAnchor, constant: 62),
            
            buttonThree.widthAnchor.constraint(equalToConstant: buttonWidth),
            buttonThree.heightAnchor.constraint(equalToConstant: buttonHeight),
            buttonThree.leadingAnchor.constraint(equalTo: buttonTwo.trailingAnchor, constant: 35),
            buttonThree.topAnchor.constraint(equalTo: buttonTwo.topAnchor),
            
            scrollView.topAnchor.constraint(equalTo: buttonTwo.bottomAnchor, constant: 30),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addChildVCs()
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(children.count), height: scrollView.bounds.height)
        
        //        NotificationCenter.default.addObserver(self,
        //                                               selector: #selector(self.toMixPostColorView),
        //                                               name: NSNotification.Name("ToMixPostColorView"),
        //                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
}


// MARK: - LobbyLayoutDelegate

extension LobbyViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y == 0 {
            let pageWidth = scrollView.bounds.width
            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            
            if currentIndex != currentPage {
                currentIndex = currentPage
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        
        for button in buttons {
            button.isSelected = false
        }
        
        buttons[currentPage].isSelected = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
            self.scrollView.contentOffset.y = 0
        }
    }
}

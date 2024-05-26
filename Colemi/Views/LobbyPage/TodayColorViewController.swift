//
//  TodayColorViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/25/24.
//

import UIKit

class TodayColorViewController: UIViewController {
    
    var currentIndex: Int = 0
    var buttons: [UIButton] = []
    var bottomLabels: [UILabel] = []
    var buttonWidth: CGFloat = 25
    var buttonHeight: CGFloat = 25
    
    var userData: UserManager?
    
    var indicatorLeading: NSLayoutConstraint?
    
    private lazy var firstChild = FirstColorViewController()
    private lazy var secondChild = SecondColorViewController()
    private lazy var thirdChild = ThirdColorViewController()
    
    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColorProperty.darkColor.getColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var buttonOne = createButton()
    lazy var buttonTwo = createButton()
    lazy var buttonThree = createButton()
    
    func createButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case buttonOne:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        case buttonTwo:
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: true)
        case buttonThree:
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width * 2, y: 0), animated: true)
        default:
            break
        }
    }
    
    func makeBottomLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "滑到底囉～！"
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 18)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        
        return label
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
        addChild(firstChild)
        addChild(secondChild)
        addChild(thirdChild)
        
        for (index, childVC) in children.enumerated() {
            childVC.view.frame = CGRect(x: CGFloat(index) * scrollView.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            bottomLabels.append(makeBottomLabel())
            scrollView.addSubview(childVC.view)
            scrollView.addSubview(bottomLabels[index])
            
            NSLayoutConstraint.activate([
                bottomLabels[index].topAnchor.constraint(equalTo: childVC.view.bottomAnchor, constant: 80),
                bottomLabels[index].centerXAnchor.constraint(equalTo: childVC.view.centerXAnchor)
            ])
            
            childVC.didMove(toParent: self)
        }
    }
    
    private func setUpUI() {
        
        view.addSubview(scrollView)
        view.addSubview(buttonOne)
        view.addSubview(buttonTwo)
        view.addSubview(buttonThree)
        view.addSubview(indicatorView)
        
        buttons.append(buttonOne)
        buttons.append(buttonTwo)
        buttons.append(buttonThree)
        
        indicatorLeading = indicatorView.centerXAnchor.constraint(equalTo: buttonOne.centerXAnchor)
        indicatorLeading?.isActive = true
        
        NSLayoutConstraint.activate([
            buttonOne.widthAnchor.constraint(equalToConstant: buttonWidth),
            buttonOne.heightAnchor.constraint(equalToConstant: buttonHeight),
            buttonOne.trailingAnchor.constraint(equalTo: buttonTwo.leadingAnchor, constant: -buttonWidth * 2),
            buttonOne.topAnchor.constraint(equalTo: buttonTwo.topAnchor),
            
            buttonTwo.widthAnchor.constraint(equalToConstant: buttonWidth),
            buttonTwo.heightAnchor.constraint(equalToConstant: buttonHeight),
            buttonTwo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonTwo.topAnchor.constraint(equalTo: view.topAnchor),
            
            buttonThree.widthAnchor.constraint(equalToConstant: buttonWidth),
            buttonThree.heightAnchor.constraint(equalToConstant: buttonHeight),
            buttonThree.leadingAnchor.constraint(equalTo: buttonTwo.trailingAnchor, constant: buttonWidth * 2),
            buttonThree.topAnchor.constraint(equalTo: buttonTwo.topAnchor),
            
            indicatorView.widthAnchor.constraint(equalToConstant: 5),
            indicatorView.heightAnchor.constraint(equalToConstant: 5),
            indicatorView.topAnchor.constraint(equalTo: buttonOne.bottomAnchor, constant: 10),
            
            scrollView.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 15),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        addChildVCs()
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(children.count), height: scrollView.bounds.height)
    }
    
    override func viewDidLayoutSubviews() {
        indicatorView.layer.cornerRadius = indicatorView.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userData = UserManager.shared
        
        if let userData = userData {
            if userData.colorSetToday.count == 3 {
                for index in 0..<buttons.count {
                    buttons[index].backgroundColor = UIColor(hex: userData.colorSetToday[index])
                }
            }
        }
    }
}

// MARK: UIScrollViewDelegate

extension TodayColorViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
                // scrollView.contentOffset.y = 0
        } else {
            let pageWidth = scrollView.bounds.width
            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            
            if currentIndex != currentPage {
                currentIndex = currentPage
                print("Switched to child view controller at index \(currentIndex)")
                
                switch currentIndex {
                case 0:
                    let vc = children[0] as? FirstColorViewController
                    // vc?.loadData()
                    // vc?.loadedBefore = true
                case 1:
                    let vc = children[1] as? SecondColorViewController
                    vc?.loadData()
                    vc?.loadedBefore = true
                case 2:
                    let vc = children[2] as? ThirdColorViewController
                    vc?.loadData()
                    vc?.loadedBefore = true
                default:
                    return
                }
            }
        }
        
        
        let offset = scrollView.contentOffset.x
        let scrollViewWidth = scrollView.bounds.width

        let indicatorOffset = offset / scrollViewWidth * (buttonTwo.center.x - buttonOne.center.x)

        indicatorLeading?.constant = indicatorOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
            self.scrollView.contentOffset.y = 0
        }
    }
}

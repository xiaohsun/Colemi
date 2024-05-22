//
//  FollowViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/5/24.
//

import UIKit

class FollowViewController: UIViewController {
    
    let viewModel = FollowViewModel()
    var isFollowersTapped = false
    
    var currentIndex: Int = 0
    var buttons: [UIButton] = []
    var buttonWidth: CGFloat = 60
    
    var indicatorLeading: NSLayoutConstraint?
    
    private lazy var followersViewController = FollowersViewController()
    private lazy var followingsViewController = FollowingsViewController()
    
    private func addChildVCs() {
        addChild(followersViewController)
        addChild(followingsViewController)
        
        followersViewController.viewModel = viewModel
        followingsViewController.viewModel = viewModel
        
        for (index, childVC) in children.enumerated() {
            childVC.view.frame = CGRect(x: CGFloat(index) * scrollView.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            scrollView.addSubview(childVC.view)
            childVC.didMove(toParent: self)
        }
    }
    
    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColorProperty.darkColor.getColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var buttonOne: UIButton = {
        let button = UIButton()
        button.setTitle("粉絲", for: .normal)
        button.titleLabel?.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 18)
        button.setTitleColor(ThemeColorProperty.darkColor.getColor(), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var buttonTwo: UIButton = {
        let button = UIButton()
        button.setTitle("追蹤中", for: .normal)
        button.titleLabel?.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 18)
        button.setTitleColor(ThemeColorProperty.darkColor.getColor(), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case buttonOne:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        case buttonTwo:
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: true)
        default:
            break
        }
    }
    
    func setUpNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(popNav))
        navigationItem.leftBarButtonItem?.tintColor = ThemeColorProperty.darkColor.getColor()
        
        navigationItem.title = viewModel.userName
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 18) ?? UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: ThemeColorProperty.darkColor.getColor()]
    }
    
    @objc private func popNav() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpUI() {
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        view.addSubview(scrollView)
        view.addSubview(buttonOne)
        view.addSubview(buttonTwo)
        view.addSubview(indicatorView)
        
        buttons.append(buttonOne)
        buttons.append(buttonTwo)
        
        indicatorLeading = indicatorView.centerXAnchor.constraint(equalTo: buttonOne.centerXAnchor)
        indicatorLeading?.isActive = true
        
        NSLayoutConstraint.activate([
            buttonOne.widthAnchor.constraint(equalToConstant: buttonWidth),
            buttonOne.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -80),
            buttonOne.topAnchor.constraint(equalTo: buttonTwo.topAnchor),
            
            buttonTwo.widthAnchor.constraint(equalToConstant: buttonWidth),
            buttonTwo.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 80),
            buttonTwo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            indicatorView.widthAnchor.constraint(equalToConstant: 5),
            indicatorView.heightAnchor.constraint(equalToConstant: 5),
            indicatorView.topAnchor.constraint(equalTo: buttonOne.bottomAnchor, constant: 5),
            
            scrollView.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 15),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
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
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        addChildVCs()
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(children.count), height: scrollView.bounds.height)
        
        if !isFollowersTapped {
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        indicatorView.layer.cornerRadius = indicatorView.frame.width / 2
    }
}

extension FollowViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
                scrollView.contentOffset.y = 0
        } else {
            let pageWidth = scrollView.bounds.width
            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            
            if currentIndex != currentPage {
                currentIndex = currentPage
                print("Switched to child view controller at index \(currentIndex)")
                
//                switch currentIndex {
//                case 0:
//                    let vc = children[0] as? FollowersViewController
//                    // vc?.loadData()
//                    // vc?.loadedBefore = true
//                case 1:
//                    let vc = children[1] as? FollowingsViewController
//                    // vc?.loadData()
//                    // vc?.loadedBefore = true
//                default:
//                    return
//                }
            }
        }
        
        
        let offset = scrollView.contentOffset.x
        let scrollViewWidth = scrollView.bounds.width

        let indicatorOffset = offset / scrollViewWidth * (buttonTwo.center.x - buttonOne.center.x)

        indicatorLeading?.constant = indicatorOffset
    }
}

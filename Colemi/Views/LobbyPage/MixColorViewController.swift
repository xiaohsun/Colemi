//
//  MixColorViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/25/24.
//

import UIKit

class MixColorViewController: UIViewController {
    var currentIndex: Int = 0
    var buttons: [UIButton] = []
    var buttonWidth: CGFloat = 50
    var buttonHeight: CGFloat = 25
    var loadedBefore: Bool = false
    
    var indicatorLeading: NSLayoutConstraint?
    
    private lazy var firstChild = FirstColorViewController()
    private lazy var secondChild = SecondColorViewController()
    private lazy var thirdChild = ThirdColorViewController()
    
    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var buttonOne: UIButton = {
        let button = UIButton()
        button.setTitle("One", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var buttonTwo: UIButton = {
        let button = UIButton()
        button.setTitle("Two", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var buttonThree: UIButton = {
        let button = UIButton()
        button.setTitle("Three", for: .normal)
        button.backgroundColor = .black
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
        case buttonThree:
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width * 2, y: 0), animated: true)
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
        addChild(firstChild)
        addChild(secondChild)
        addChild(thirdChild)
        
        for (index, childVC) in children.enumerated() {
            childVC.view.frame = CGRect(x: CGFloat(index) * scrollView.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            scrollView.addSubview(childVC.view)
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
            buttonOne.trailingAnchor.constraint(equalTo: buttonTwo.leadingAnchor, constant: -buttonWidth),
            buttonOne.topAnchor.constraint(equalTo: buttonTwo.topAnchor),
            
            buttonTwo.widthAnchor.constraint(equalToConstant: buttonWidth),
            buttonTwo.heightAnchor.constraint(equalToConstant: buttonHeight),
            buttonTwo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonTwo.topAnchor.constraint(equalTo: view.topAnchor),
            
            buttonThree.widthAnchor.constraint(equalToConstant: buttonWidth),
            buttonThree.heightAnchor.constraint(equalToConstant: buttonHeight),
            buttonThree.leadingAnchor.constraint(equalTo: buttonTwo.trailingAnchor, constant: buttonWidth),
            buttonThree.topAnchor.constraint(equalTo: buttonTwo.topAnchor),
            
            indicatorView.widthAnchor.constraint(equalToConstant: 10),
            indicatorView.heightAnchor.constraint(equalToConstant: 10),
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
    
    override func viewWillAppear(_ animated: Bool) {
        print("Hi this is mix")
    }
    
    override func viewDidLayoutSubviews() {
        indicatorView.layer.cornerRadius = indicatorView.frame.width / 2
    }
}

// MARK: UIScrollViewDelegate

extension MixColorViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
                scrollView.contentOffset.y = 0
        } else {
            let pageWidth = scrollView.bounds.width
            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            
            if currentIndex != currentPage {
                currentIndex = currentPage
                print("Switched to child view controller at index \(currentIndex)")
            }
        }
        
        let offset = scrollView.contentOffset.x
        let scrollViewWidth = scrollView.bounds.width

        let indicatorOffset = offset / scrollViewWidth * (buttonTwo.center.x - buttonOne.center.x)

        indicatorLeading?.constant = indicatorOffset
    }
}

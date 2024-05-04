//
//  OverLayPopUp.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/4/24.
//

import UIKit

class OverLayPopUp: UIViewController {
    
    var containerViewTopCons: NSLayoutConstraint?
    var containerViewHeight: CGFloat = 180
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.6)
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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(OverLayPopUpCell.self, forCellReuseIdentifier: OverLayPopUpCell.reuseIdentifier)
        return tableView
    }()
    
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
    
    private func setUpUI() {
        view.backgroundColor = .clear
        // view.addSubview(backgroundView)
        view.addSubview(containerView)
        containerView.addSubview(tableView)
        containerView.addSubview(closeButton)
        
        containerViewTopCons = containerView.topAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewTopCons?.isActive = true
        
        NSLayoutConstraint.activate([
//            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
//            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: containerViewHeight),
            
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            closeButton.widthAnchor.constraint(equalToConstant: 10),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            
            tableView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.modalPresentationStyle = .overCurrentContext
        // viewAddGesture()
    }
    
    private func viewAddGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
    }
    
    func appear(sender: UIViewController) {
        sender.present(self, animated: false) {
            self.containerViewTopCons?.constant = -self.containerViewHeight
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func hide() {
        // self.backgroundView.alpha = 0
        self.containerViewTopCons?.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.tableView.alpha = 1
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }
    
    private func showBlockAlert() {
        let alert = UIAlertController(title: "將他封鎖", message: "對方將看不到你的貼文，也無法私訊你。", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "封鎖", style: .default, handler: { (action: UIAlertAction!) in
              print("Handle Ok logic here")
        }))

        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func showReportAlert() {
        let alert = UIAlertController(title: "檢舉他", message: "我要告死你。", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "檢舉", style: .default, handler: { (action: UIAlertAction!) in
              print("Handle Ok logic here")
        }))

        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension OverLayPopUp: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OverLayPopUpCell.reuseIdentifier, for: indexPath) as? OverLayPopUpCell else { return UITableViewCell() }
        
        if indexPath.row == 1 {
            cell.update()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            showBlockAlert()
        } else {
            showReportAlert()
        }
    }
}

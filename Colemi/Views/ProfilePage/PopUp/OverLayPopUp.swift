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
    var fromDetailPage: Bool = false
    
    let viewModel = OverLayPopUpViewModel()
    
    var reportTextDetailPage = ["檢舉貼文", "封鎖作者"]
    var reportTextProfilePage = ["檢舉", "封鎖"]
    
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
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "exclamationmark.triangle.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = ThemeColorProperty.darkColor.getColor()
        
        return imageView
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
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        containerView.addSubview(tableView)
        containerView.addSubview(closeButton)
        
        containerViewTopCons = containerView.topAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewTopCons?.isActive = true
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
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
            self.containerViewTopCons?.constant = -self.containerViewHeight
            UIView.animate(withDuration: 0.2) {
                self.backgroundView.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func hide() {
        self.containerViewTopCons?.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.backgroundView.alpha = 0
        } completion: { _ in
            self.tableView.alpha = 1
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }
    
    private func showBlockAlert() {
        let alert1 = UIAlertController(title: "將他封鎖", message: "對方將看不到你的貼文，也無法私訊你。", preferredStyle: .alert)
        let alert2 = UIAlertController(title: "已封鎖", message: "對方不會收到封鎖通知。", preferredStyle: .alert)
        
        alert1.addAction(UIAlertAction(title: "封鎖", style: .default, handler: { _ in
            Task {
                await self.viewModel.updateBlockingData()
            }
            DispatchQueue.main.async {
                alert2.addAction(UIAlertAction(title: "好的", style: .default, handler: { _ in
                    self.hide()
                }))
            }
            self.present(alert2, animated: true)
        }))
        
        alert1.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            self.hide()
        }))
        
        present(alert1, animated: true, completion: nil)
    }
    
    private func showReportAlert() {
        let alert1 = UIAlertController(title: fromDetailPage ? "檢舉貼文" : "檢舉他", message: fromDetailPage ? "若貼文違反社群守則，我們將會進行處置。" : "若對方違反社群守則，我們將會進行處置。", preferredStyle: .alert)
        let alert2 = UIAlertController(title: "已收到檢舉", message: "謝謝你，我們將會進行查證！", preferredStyle: .alert)
        
        alert1.addAction(UIAlertAction(title: "檢舉", style: .default, handler: { _ in
            print("Block!!! \(self.viewModel.otherUserID)")
            alert2.addAction(UIAlertAction(title: "好的", style: .default, handler: { _ in
                self.hide()
            }))
            self.present(alert2, animated: true)
        }))
        
        alert1.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            self.hide()
        }))
        
        present(alert1, animated: true, completion: nil)
    }
}

extension OverLayPopUp: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OverLayPopUpCell.reuseIdentifier, for: indexPath) as? OverLayPopUpCell else { return UITableViewCell() }
        
        //        if fromDetailPage {
        //            cell.label.text = reportTextDetailPage[indexPath.row]
        //        } else {
        if indexPath.row == 1 {
            cell.update()
        }
        // }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            showReportAlert()
        } else {
            showBlockAlert()
        }
    }
}

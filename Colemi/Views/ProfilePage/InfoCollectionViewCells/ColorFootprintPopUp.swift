//
//  ColorFootprintPopUp.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/12/24.
//

import UIKit

class ColorFootprintPopUp: UIViewController {
    
    var containerViewTopCons: NSLayoutConstraint?
    let viewModel = ColorFootprintPopUpViewModel()
    
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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = RadiusProperty.radiusTwenty.rawValue
        tableView.register(RankingCell.self, forCellReuseIdentifier: RankingCell.reuseIdentifier)
        return tableView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "排行榜"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 20)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        
        return label
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
    
    private func setupUI() {
        view.backgroundColor = .clear
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
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
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 10),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        backgroundAddGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUsersData {
            self.tableView.reloadData()
        }
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
            self.containerViewTopCons = self.containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            self.containerViewTopCons?.isActive = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
                self.backgroundView.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func hide() {
        self.containerViewTopCons?.isActive = false
        self.containerViewTopCons = self.containerView.topAnchor.constraint(equalTo: self.view.bottomAnchor)
        self.containerViewTopCons?.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
            self.view.layoutIfNeeded()
            self.backgroundView.alpha = 0
        } completion: { _ in
            self.tableView.alpha = 1
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }
}

extension ColorFootprintPopUp: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.topTenUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RankingCell.reuseIdentifier, for: indexPath) as? RankingCell else { return UITableViewCell() }
        let user = viewModel.topTenUsers[indexPath.row]
        cell.update(index: indexPath.row + 1, colorPoints: user.colorPoints, userName: user.name)
        
        return cell
    }
}

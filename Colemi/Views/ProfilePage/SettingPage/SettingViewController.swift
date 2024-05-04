//
//  SettingViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/3/24.
//

import UIKit
import PhotosUI

class SettingViewController: UIViewController {
    
    let userData = UserManager.shared
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        button.setImage(.backIcon.withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    @objc private func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AvatarEditCell.self, forCellReuseIdentifier: AvatarEditCell.reuseIdentifier)
        tableView.register(NormalSettingCell.self, forCellReuseIdentifier: NormalSettingCell.reuseIdentifier)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = ThemeColorProperty.darkColor.getColor()
        
        return tableView
    }()
    
    private func setUpUI() {
        view.backgroundColor = ThemeColorProperty.darkColor.getColor()
        
        view.addSubview(tableView)
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 15),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),
            
            tableView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AvatarEditCell.reuseIdentifier, for: indexPath) as? AvatarEditCell else { return UITableViewCell() }
            cell.delegate = self
            cell.update(avatarUrl: userData.avatarPhoto)
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NormalSettingCell.reuseIdentifier, for: indexPath) as? NormalSettingCell else { return UITableViewCell() }
            
            return cell
        }
    }
}

extension SettingViewController: AvatarEditCellDelegate {
    func presentPHPicker(_ pickerVC: PHPickerViewController) {
        present(pickerVC, animated: true)
    }
}

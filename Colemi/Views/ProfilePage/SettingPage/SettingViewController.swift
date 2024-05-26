//
//  SettingViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/3/24.
//

import UIKit
import PhotosUI
import MessageUI

class SettingViewController: UIViewController {
    
    let userData = UserManager.shared
    let avatarEditCell = AvatarEditCell()
    let signOutCell = SignOutCell()
    let deleteAccountCell = DeleteAccountCell()
    let contactDeveloperCell = ContactDeveloperCell()
    let changeNameCell = ChangeNameCell()
    let eulaCell = EULACell()
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(popNav))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.title = "設定"
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 18), NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    @objc private func popNav() {
        navigationController?.popViewController(animated: true)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NormalSettingCell.self, forCellReuseIdentifier: NormalSettingCell.reuseIdentifier)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = ThemeColorProperty.darkColor.getColor()
        
        return tableView
    }()
    
    private func setupUI() {
        view.backgroundColor = ThemeColorProperty.darkColor.getColor()
        
        setupNavigationBar()
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        deleteAccountCell.delegate = self
        signOutCell.delegate = self
        contactDeveloperCell.delegate = self
        eulaCell.delegate = self
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            avatarEditCell.delegate = self
            avatarEditCell.update(avatarUrl: userData.avatarPhoto)
            
            return avatarEditCell
            
        } else if indexPath.row == 2 {
            return changeNameCell
            
        } else if indexPath.row == 3 {
            return signOutCell
            
        } else if indexPath.row == 4 {
            return deleteAccountCell
            
        } else if indexPath.row == 5 {
            return contactDeveloperCell
            
        } else if indexPath.row == 6 {
            return eulaCell
            
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

extension SettingViewController: DeleteAccountCellDelegate {
    func presentAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }
}

extension SettingViewController: ContactDeveloperCellDelegate {
    func presentComposeVC() {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients(["bobbytesting0123@gmail.com"])
            composeVC.setSubject("Colemi! \(UserManager.shared.name)想回報問題！")
            composeVC.setMessageBody("""
                                     ID: \(UserManager.shared.id)
                                     請描述你所遇到的問題：
                                     
                                     
                                     """, isHTML: false)
            present(composeVC, animated: true)
            
        } else {
            if let mailURLString = "mailto:\("example@example.com")?subject=\("Example Subject")".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   let mailURL = URL(string: mailURLString) {
                    if UIApplication.shared.canOpenURL(mailURL) { //check not needed, but if desired add mailto to LSApplicationQueriesSchemes in Info.plist
                        view.window?.windowScene?.open(mailURL, options: nil, completionHandler: nil)
                    } else {
                        let alert = UIAlertController(title: "歡迎聯繫我", message: "開發者信箱：bobbytesting0123@gmail.com", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "好的", style: .default))
                        
                        present(alert, animated: true, completion: nil)
                    }
                }
        }
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true)
    }
}

extension SettingViewController: SignOutCellDelegate {
    func presentSignOutAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }
}

extension SettingViewController: EULACellDelegate {
    func presentEULAPopUp() {
        let eulaPopUp = EULAPopUp()
        eulaPopUp.appear(sender: self)
    }
}

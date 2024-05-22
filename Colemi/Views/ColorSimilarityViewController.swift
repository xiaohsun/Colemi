//
//  ColorSimilarityViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/14/24.
//

import UIKit

class ColorSimilarityViewController: UIViewController {
    
    var selectedImage: UIImage?
    var selectedImageURL: String?
    var selectedImageData: Data?
    let cloudVisionManager = CloudVisionManager()
    var colors: [Color] = []
    var colorViews: [UIView] = []
    let viewModel = ColorSimilarityViewModel()
    var colorDistances: [Double] = []
    var roundedColorSimilarity: [Double] = []
    
    var colorDistancesString: [String] = []
    
    // 測試用
    // var roundedColorSimilarity: [Double] = [1,1,1,1,1]
    // let fakeUIColors: [UIColor] = [UIColor.red, UIColor.green, UIColor.blue, UIColor.yellow, UIColor.brown]
    
    var distanceLabelBottomConstraint: NSLayoutConstraint?
    var colorViewOneTrailingConstraint: NSLayoutConstraint?
    var colorViewTwoLeadingConstraint: NSLayoutConstraint?
    var colorViewThreeTrailingConstraint: NSLayoutConstraint?
    var colorViewFourLeadingConstraint: NSLayoutConstraint?
    var colorViewFiveTrailingConstraint: NSLayoutConstraint?
    var totalCountsLabelBottomConstraint: NSLayoutConstraint?
    var showSimilarityImageViewXCons: NSLayoutConstraint?
    var showSimilarityImageViewTopCons: NSLayoutConstraint?
    var searchColorLabelTopCons: NSLayoutConstraint?
    var missionColorViewWidthCons: NSLayoutConstraint?
    
    var colorViewWidthMutiplier = 0.72
    var colorViewHeightMutiplier = 0.11
    
    var animationCount = 0
    
    var totalBonusCount: Double = 0
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        
        if let selectedImage = selectedImage {
            imageView.image = selectedImage
        }
        
        return imageView
    }()
    
    lazy var backIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = .backIcon
        imageView.alpha = 0
        
        return imageView
    }()
    
    lazy var lineIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = .lineIcon
        imageView.alpha = 0
        
        return imageView
    }()
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "點擊螢幕"
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 22)
        label.textAlignment = .center
        label.alpha = 0
        
        return label
    }()
    
    lazy var missionColorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = RadiusProperty.radiusTwenty.rawValue
        
        return view
    }()
    
    private func createColorView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        // colorViews.append(view)
        return view
    }
    
    private func setupColorViews() {
        for (index, color) in colors.enumerated() {
            let colorView = colorViews[index]
            let red = CGFloat(color.color.red ?? 0) / 255
            let green = CGFloat(color.color.green ?? 0) / 255
            let blue = CGFloat(color.color.blue ?? 0) / 255
            colorView.layer.cornerRadius = view.frame.width / 9
            colorView.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        }
        
        // 測試用
        //        for (index, colorView) in colorViews.enumerated() {
        //            let colorView = colorViews[index]
        //            colorView.layer.cornerRadius = view.frame.width / 9
        //            colorView.backgroundColor = fakeUIColors[index]
        //        }
    }
    
    lazy var showSimilarityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = ThemeColorProperty.darkColor.getColor()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showSimilarityButtonTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    lazy var searchColorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "分析顏色"
        label.font = ThemeFontProperty.GenSenRoundedTW_B.getFont(size: 24)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        
        return label
    }()
    
    lazy var congratsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "恭喜！"
        label.font = ThemeFontProperty.GenSenRoundedTW_H.getFont(size: 34)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.alpha = 0
        
        return label
    }()
    
    lazy var totalCountsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ThemeFontProperty.GenSenRoundedTW_H.getFont(size: 34)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.alpha = 0
        
        return label
    }()
    
    lazy var backToMainPageButton: UIButton = {
        let button = UIButton()
        button.setTitle("探索貼文", for: .normal)
        button.backgroundColor = ThemeColorProperty.lightColor.getColor()
        button.addTarget(self, action: #selector(backToMainPageButtonTapped), for: .touchUpInside)
        button.setTitleColor(ThemeColorProperty.darkColor.getColor(), for: .normal)
        button.titleLabel?.font = ThemeFontProperty.GenSenRoundedTW_B.getFont(size: 28)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        
        return button
    }()
    
    @objc private func backToMainPageButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func searchColorAnimation(completion: (() -> Void)? = nil) {
        showSimilarityImageViewXCons?.constant = imageView.frame.width / 2
        showSimilarityImageViewTopCons?.constant = -imageView.frame.height / 2.3
        searchColorLabelTopCons?.constant = 60
        self.searchColorLabel.text = "分析顏色中"
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.showSimilarityImageViewXCons?.constant = -0
            self.showSimilarityImageViewTopCons?.constant = -self.imageView.frame.height - 30
            UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
                self.searchColorLabel.text = "分析顏色中."
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.showSimilarityImageViewXCons?.constant = -self.imageView.frame.width / 2
                self.showSimilarityImageViewTopCons?.constant = -self.imageView.frame.height + self.imageView.frame.height / 4
                
                UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
                    self.searchColorLabel.text = "分析顏色中.."
                    self.view.layoutIfNeeded()
                } completion: { _ in
                    completion?()
                }
            }
        }
    }
    
    @objc private func showSimilarityButtonTapped() {
        
        searchColorAnimation {
            self.searchColorAnimation {
                
                UIView.animate(withDuration: 0.4, delay: 0.4) {
                    self.imageView.alpha = 0
                    self.showSimilarityImageView.alpha = 0
                    self.searchColorLabel.alpha = 0
                    
                } completion: { _ in
                    self.missionColorViewWidthCons?.constant = self.view.frame.width * 0.25
                    
                    UIView.animate(withDuration: 0.6, delay: 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6) {
                        self.view.layoutIfNeeded()
                        self.distanceLabel.alpha = 1
                    } completion: { _ in
                        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.colorViewsMoveUp))
                        self.view.addGestureRecognizer(tapGesture)
                        self.view.isUserInteractionEnabled = true
                        
                        
                        self.setupColorViews()
                        
                        if let selectedUIColor = UIColor(hex: self.viewModel.userData.colorToday) {
                            
                            self.colorDistances = self.viewModel.caculateColorDistance(selectedUIColor: selectedUIColor, colors: self.colors)
                            
                            for colorDistance in self.colorDistances {
                                
                                if colorDistance < 100 {
                                    let roundedNumber = ((100.0 - colorDistance) * 10).rounded() / 10
                                    self.roundedColorSimilarity.append(roundedNumber)
                                    self.colorDistancesString.append(String(100 - roundedNumber))
                                    self.totalBonusCount += roundedNumber
                                } else {
                                    self.roundedColorSimilarity.append(0)
                                    self.colorDistancesString.append(String(100))
                                    self.totalBonusCount += 0
                                }
                            }
                            self.totalBonusCount = self.totalBonusCount.rounded()
                            self.totalCountsLabel.text = "顏色足跡 +\(String(format: "%.0f", self.totalBonusCount))"
                            
                            self.viewModel.updatePostData(colorPoints: Int(self.totalBonusCount))
                            self.viewModel.updateUserData(colorPoints: Int(self.totalBonusCount))
                        }
                    }
                }
            }
        }
    }
    
    @objc private func colorViewsMoveUp() {
        if colorDistancesString.count == 5 {
            if animationCount == 0 {
                distanceLabelBottomConstraint?.constant = -40
                colorViewOneTrailingConstraint?.constant = -20
                distanceLabel.text = "相似度 \(roundedColorSimilarity[0])"
            } else if animationCount == 1 {
                colorViewTwoLeadingConstraint?.constant = 20
                distanceLabelBottomConstraint?.constant -= colorViews[0].frame.height
                distanceLabel.text = "相似度 \(roundedColorSimilarity[1])"
            } else if animationCount == 2 {
                colorViewThreeTrailingConstraint?.constant = -50
                distanceLabelBottomConstraint?.constant -= colorViews[0].frame.height
                distanceLabel.text = "相似度 \(roundedColorSimilarity[2])"
            } else if animationCount == 3 {
                colorViewFourLeadingConstraint?.constant = 20
                distanceLabelBottomConstraint?.constant -= colorViews[0].frame.height
                distanceLabel.text = "相似度 \(roundedColorSimilarity[3])"
            } else if animationCount == 4 {
                colorViewFiveTrailingConstraint?.constant = -10
                distanceLabelBottomConstraint?.constant -= colorViews[0].frame.height
                distanceLabel.text = "相似度 \(roundedColorSimilarity[4])"
            }
            
            
            if self.animationCount == 5 {
                UIView.animate(withDuration: 0.4) {
                    self.missionColorView.alpha = 0
                    self.distanceLabel.alpha = 0
                    self.congratsLabel.alpha = 1
                    self.totalCountsLabel.alpha = 1
                } completion: { _ in
                    self.totalCountsLabelBottomConstraint?.isActive = false
                    self.totalCountsLabelBottomConstraint = self.totalCountsLabel.bottomAnchor.constraint(equalTo: self.backToMainPageButton.topAnchor, constant: -self.view.frame.height * self.colorViewHeightMutiplier / 1.3)
                    self.totalCountsLabelBottomConstraint?.isActive = true
                    UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
                        self.view.layoutIfNeeded()
                    } completion: { _ in
                        UIView.animate(withDuration: 0.4, delay: 0.2) {
                            self.backIconImageView.alpha = 1
                            self.lineIconImageView.alpha = 1
                            self.backToMainPageButton.alpha = 1
                        }
                    }
                }
            }
            
            view.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.view.isUserInteractionEnabled = true
                self.animationCount += 1
            }
        }
    }
    
    private func setUpUI() {
        let colorViewOne = createColorView()
        let colorViewTwo = createColorView()
        let colorViewThree = createColorView()
        let colorViewFour = createColorView()
        let colorViewFive = createColorView()
        
        colorViews = [colorViewOne, colorViewTwo, colorViewThree, colorViewFour, colorViewFive]
        
        for colorView in colorViews {
            view.addSubview(colorView)
        }
        
        view.addSubview(imageView)
        view.addSubview(missionColorView)
        view.addSubview(showSimilarityImageView)
        view.addSubview(distanceLabel)
        view.addSubview(congratsLabel)
        view.addSubview(totalCountsLabel)
        view.addSubview(backToMainPageButton)
        view.addSubview(backIconImageView)
        view.addSubview(lineIconImageView)
        view.addSubview(searchColorLabel)
        
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        missionColorView.backgroundColor = UIColor(hex: viewModel.userData.colorToday)
        
        distanceLabelBottomConstraint = distanceLabel.bottomAnchor.constraint(equalTo: colorViewOne.topAnchor, constant: -320)
        colorViewOneTrailingConstraint =
        colorViewOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: view.frame.width * colorViewWidthMutiplier)
        colorViewTwoLeadingConstraint = colorViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -view.frame.width * colorViewWidthMutiplier)
        colorViewThreeTrailingConstraint = colorViewThree.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: view.frame.width * colorViewWidthMutiplier)
        colorViewFourLeadingConstraint =
        colorViewFour.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  -view.frame.width * colorViewWidthMutiplier)
        colorViewFiveTrailingConstraint = colorViewFive.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: view.frame.width * colorViewWidthMutiplier)
        
        distanceLabelBottomConstraint?.isActive = true
        colorViewOneTrailingConstraint?.isActive = true
        colorViewTwoLeadingConstraint?.isActive = true
        colorViewThreeTrailingConstraint?.isActive = true
        colorViewFourLeadingConstraint?.isActive = true
        colorViewFiveTrailingConstraint?.isActive = true
        
        totalCountsLabelBottomConstraint = totalCountsLabel.bottomAnchor.constraint(equalTo: view.topAnchor)
        totalCountsLabelBottomConstraint?.isActive = true
        
        showSimilarityImageViewXCons = showSimilarityImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        showSimilarityImageViewXCons?.isActive = true
        showSimilarityImageViewTopCons = showSimilarityImageView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25)
        showSimilarityImageViewTopCons?.isActive = true
        
        searchColorLabelTopCons = searchColorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: view.frame.height * 0.1)
        searchColorLabelTopCons?.isActive = true
        
        missionColorViewWidthCons = missionColorView.widthAnchor.constraint(equalToConstant: 0)
        missionColorViewWidthCons?.isActive = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 240),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 3/4),
            
            showSimilarityImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            showSimilarityImageView.widthAnchor.constraint(equalTo: showSimilarityImageView.heightAnchor),
            
            searchColorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            missionColorView.centerYAnchor.constraint(equalTo: distanceLabel.topAnchor, constant: -view.frame.height * 0.1),
            missionColorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            missionColorView.heightAnchor.constraint(equalTo: missionColorView.widthAnchor),
            
            distanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            distanceLabel.widthAnchor.constraint(equalToConstant: 140),
            
            colorViewOne.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            colorViewOne.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: colorViewWidthMutiplier),
            colorViewOne.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: colorViewHeightMutiplier),
            
            colorViewTwo.bottomAnchor.constraint(equalTo: colorViewOne.topAnchor),
            colorViewTwo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: colorViewWidthMutiplier),
            colorViewTwo.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: colorViewHeightMutiplier),
            
            colorViewThree.bottomAnchor.constraint(equalTo: colorViewTwo.topAnchor),
            colorViewThree.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: colorViewWidthMutiplier),
            colorViewThree.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: colorViewHeightMutiplier),
            
            colorViewFour.bottomAnchor.constraint(equalTo: colorViewThree.topAnchor),
            colorViewFour.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: colorViewWidthMutiplier),
            colorViewFour.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: colorViewHeightMutiplier),
            
            colorViewFive.bottomAnchor.constraint(equalTo: colorViewFour.topAnchor),
            colorViewFive.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: colorViewWidthMutiplier),
            colorViewFive.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: colorViewHeightMutiplier),
            
            congratsLabel.bottomAnchor.constraint(equalTo: totalCountsLabel.topAnchor, constant: -10),
            congratsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            
            // totalCountsLabel.bottomAnchor.constraint(equalTo: backToMainPageButton.topAnchor, constant: -view.frame.height * colorViewHeightMutiplier / 1.3),
            totalCountsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            
            backToMainPageButton.bottomAnchor.constraint(equalTo: colorViewFive.topAnchor, constant:  -view.frame.height * colorViewHeightMutiplier / 1.3),
            backToMainPageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backIconImageView.centerYAnchor.constraint(equalTo: backToMainPageButton.centerYAnchor),
            backIconImageView.heightAnchor.constraint(equalToConstant: 35),
            backIconImageView.widthAnchor.constraint(equalToConstant: 35),
            backIconImageView.trailingAnchor.constraint(equalTo: backToMainPageButton.leadingAnchor, constant: -30),
            
            lineIconImageView.centerYAnchor.constraint(equalTo: backToMainPageButton.centerYAnchor),
            lineIconImageView.heightAnchor.constraint(equalToConstant: 25),
            lineIconImageView.widthAnchor.constraint(equalToConstant: 25),
            lineIconImageView.leadingAnchor.constraint(equalTo: backToMainPageButton.trailingAnchor, constant: 30)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        cloudVisionManager.delegate = self
        if let selectedImageData = selectedImageData, let url = selectedImageURL {
            cloudVisionManager.analyzeImageWithVisionAPI(imageData: selectedImageData, url: url)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        missionColorView.layer.cornerRadius = missionColorView.frame.width / 2
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("BackToMainPage"), object: nil)
    }
}

extension ColorSimilarityViewController: CloudVisionManagerDelegate {
    func getColorsRGB(colors: [Color]) {
        self.colors = colors
    }
}

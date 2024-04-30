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
    let colorSimilarityViewModel = ColorSimilarityViewModel()
    let userManager = UserManager.shared
    var colorDistances: [Double] = []
    var colorDistancesString: [String] = []
    let fakeUIColors: [UIColor] = [UIColor.red, UIColor.green, UIColor.blue, UIColor.yellow, UIColor.brown]
    
    var distanceLabelBottomConstraint: NSLayoutConstraint?
    var colorViewOneTrailingConstraint: NSLayoutConstraint?
    var colorViewTwoLeadingConstraint: NSLayoutConstraint?
    var colorViewThreeTrailingConstraint: NSLayoutConstraint?
    var colorViewFourLeadingConstraint: NSLayoutConstraint?
    var colorViewFiveTrailingConstraint: NSLayoutConstraint?
    
    let colorViewHeight: CGFloat = 80
    let colorViewWidth: CGFloat = 260
    
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
    
    //    lazy var similarityLabel: UILabel = {
    //        let label = UILabel()
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        label.numberOfLines = 0
    //        label.text = "顏色差異為"
    //
    //        return label
    //    }()
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "點擊螢幕"
        label.textAlignment = .center
        label.alpha = 0
        
        return label
    }()
    
    lazy var missionColorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        view.alpha = 0
        
        return view
    }()
    
    private func createColorView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 40
        // colorViews.append(view)
        return view
    }
    
    private func setupColorViews() {
        for (index, color) in colors.enumerated() {
            let colorView = colorViews[index]
            let red = CGFloat(color.color.red) / 255
            let green = CGFloat(color.color.green) / 255
            let blue = CGFloat(color.color.blue) / 255
            colorView.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        }
        //
        //        for (index, colorView) in colorViews.enumerated() {
        //            let colorView = colorViews[index]
        //            colorView.backgroundColor = fakeUIColors[index]
        //        }
    }
    
    lazy var showSimilarityButton: UIButton = {
        let button = UIButton()
        button.setTitle("萃取顏色", for: .normal)
        button.backgroundColor = ThemeColorProperty.darkColor.getColor()
        button.addTarget(self, action: #selector(showSimilarityButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = RadiusProperty.radiusTwenty.rawValue
        
        return button
    }()
    
    lazy var congratsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "恭喜"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.alpha = 0
        
        return label
    }()
    
    lazy var totalCountsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        
        return button
    }()
    
    @objc private func backToMainPageButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func showSimilarityButtonTapped() {
        if colors.count == 5 {
            setupColorViews()
            
            UIView.animate(withDuration: 0.4) {
                self.imageView.alpha = 0
                self.showSimilarityButton.alpha = 0
                self.missionColorView.alpha = 1
                self.distanceLabel.alpha = 1
            }
            
            if let selectedUIColor = userManager.selectedUIColor {
                colorDistances = colorSimilarityViewModel.caculateColorDistance(selectedUIColor: selectedUIColor, colors: colors)
                print(colorDistances)
                for colorDistance in colorDistances {
                    
                    let roundedNumber = (colorDistance * 10).rounded() / 10
                    // let formattedSimilarity = String(format: "%.1f", colorDistance)
                    if roundedNumber < 100 {
                        colorDistancesString.append(String(roundedNumber))
                        totalBonusCount += (100 - roundedNumber)
                    } else {
                        colorDistancesString.append(String(100))
                        totalBonusCount += 0
                    }
                }
                totalBonusCount = (totalBonusCount / 10).rounded()
                totalCountsLabel.text = "顏色里程 +\(String(format: "%.0f", totalBonusCount))"
                
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.colorViewsMoveUp))
                self.view.addGestureRecognizer(tapGesture)
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    //    @objc private func colorViewsMoveUp() {
    //        self.firstColorViewTopConstraint?.constant -= self.colorViewHeight
    //        view.isUserInteractionEnabled = false
    //        UIView.animate(withDuration: 0.4) {
    //            self.view.layoutIfNeeded()
    //        } completion: { _ in
    //            self.view.isUserInteractionEnabled = true
    //        }
    //    }
    
    @objc private func colorViewsMoveUp() {
        if colorDistancesString.count == 5 {
            if animationCount == 0 {
                colorViewOneTrailingConstraint?.constant = -20
                distanceLabel.text = "距離為 \(colorDistancesString[0])"
            } else if animationCount == 1 {
                colorViewTwoLeadingConstraint?.constant = 10
                distanceLabelBottomConstraint?.constant -= colorViewHeight
                distanceLabel.text = "距離為 \(colorDistancesString[1])"
            } else if animationCount == 2 {
                colorViewThreeTrailingConstraint?.constant = -30
                distanceLabelBottomConstraint?.constant -= colorViewHeight
                distanceLabel.text = "距離為 \(colorDistancesString[2])"
            } else if animationCount == 3 {
                colorViewFourLeadingConstraint?.constant = 20
                distanceLabelBottomConstraint?.constant -= colorViewHeight
                distanceLabel.text = "距離為 \(colorDistancesString[3])"
            } else if animationCount == 4 {
                colorViewFiveTrailingConstraint?.constant = -10
                distanceLabelBottomConstraint?.constant -= colorViewHeight
                distanceLabel.text = "距離為 \(colorDistancesString[4])"
            }
            
            view.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.4) {
                if self.animationCount == 5 {
                    self.missionColorView.alpha = 0
                    self.distanceLabel.alpha = 0
                    self.congratsLabel.alpha = 1
                    self.backToMainPageButton.alpha = 1
                    self.totalCountsLabel.alpha = 1
                }
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
        // view.addSubview(similarityLabel)
        view.addSubview(missionColorView)
        view.addSubview(showSimilarityButton)
        view.addSubview(distanceLabel)
        view.addSubview(congratsLabel)
        view.addSubview(totalCountsLabel)
        view.addSubview(backToMainPageButton)
        
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        missionColorView.backgroundColor = userManager.selectedUIColor
        
        distanceLabelBottomConstraint = distanceLabel.bottomAnchor.constraint(equalTo: colorViewOne.topAnchor, constant: -40)
        colorViewOneTrailingConstraint =
        colorViewOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: colorViewWidth)
        colorViewTwoLeadingConstraint = colorViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -colorViewWidth)
        colorViewThreeTrailingConstraint = colorViewThree.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: colorViewWidth)
        colorViewFourLeadingConstraint =
        colorViewFour.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  -colorViewWidth)
        colorViewFiveTrailingConstraint = colorViewFive.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: colorViewWidth)
        
        distanceLabelBottomConstraint?.isActive = true
        colorViewOneTrailingConstraint?.isActive = true
        colorViewTwoLeadingConstraint?.isActive = true
        colorViewThreeTrailingConstraint?.isActive = true
        colorViewFourLeadingConstraint?.isActive = true
        colorViewFiveTrailingConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 3/4),
            
            // similarityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // similarityLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            
            showSimilarityButton.heightAnchor.constraint(equalToConstant: 50),
            showSimilarityButton.widthAnchor.constraint(equalToConstant: 100),
            showSimilarityButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50),
            showSimilarityButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            missionColorView.bottomAnchor.constraint(equalTo: distanceLabel.topAnchor, constant: -30),
            missionColorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            missionColorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            missionColorView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            
            distanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            distanceLabel.widthAnchor.constraint(equalToConstant: 100),
            
            colorViewOne.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            colorViewOne.widthAnchor.constraint(equalToConstant: colorViewWidth),
            colorViewOne.heightAnchor.constraint(equalToConstant: colorViewHeight),
            
            colorViewTwo.bottomAnchor.constraint(equalTo: colorViewOne.topAnchor),
            colorViewTwo.widthAnchor.constraint(equalToConstant: colorViewWidth),
            colorViewTwo.heightAnchor.constraint(equalToConstant: colorViewHeight),
            
            colorViewThree.bottomAnchor.constraint(equalTo: colorViewTwo.topAnchor),
            colorViewThree.widthAnchor.constraint(equalToConstant: colorViewWidth),
            colorViewThree.heightAnchor.constraint(equalToConstant: colorViewHeight),
            
            colorViewFour.bottomAnchor.constraint(equalTo: colorViewThree.topAnchor),
            colorViewFour.widthAnchor.constraint(equalToConstant: colorViewWidth),
            colorViewFour.heightAnchor.constraint(equalToConstant: colorViewHeight),
            
            colorViewFive.bottomAnchor.constraint(equalTo: colorViewFour.topAnchor),
            colorViewFive.widthAnchor.constraint(equalToConstant: colorViewWidth),
            colorViewFive.heightAnchor.constraint(equalToConstant: colorViewHeight),
            
            congratsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            congratsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            totalCountsLabel.topAnchor.constraint(equalTo: congratsLabel.bottomAnchor, constant: 10),
            totalCountsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backToMainPageButton.topAnchor.constraint(equalTo: totalCountsLabel.bottomAnchor, constant: 80),
            backToMainPageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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

//
//  CustomTabBarController.swift
//  Mola
//
//  Created by Onur Bostan on 1.11.2024.
//

import UIKit

class CustomTabBarController: UITabBarController {
    private var customCenterButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCenterButton()
        addTopLineToTabBar()
    }
    
    func setupCenterButton() {
        let buttonSize: CGFloat = 45
        customCenterButton = UIButton(frame: CGRect(x: (view.bounds.width / 2) - (buttonSize / 2),
                                                    y: -5,
                                                    width: buttonSize,
                                                    height: buttonSize))
        customCenterButton.layer.cornerRadius = buttonSize / 2
        customCenterButton.backgroundColor = .systemBlue
        customCenterButton.setImage(UIImage(systemName: "plus"), for: .normal)
        customCenterButton.tintColor = .white
        customCenterButton.layer.borderWidth = 2
        customCenterButton.layer.borderColor = UIColor.white.cgColor
        customCenterButton.layer.shadowColor = UIColor.black.cgColor
        customCenterButton.layer.shadowOpacity = 0.3
        customCenterButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        customCenterButton.layer.shadowRadius = 3
        customCenterButton.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        tabBar.addSubview(customCenterButton)
        tabBar.bringSubviewToFront(customCenterButton)
    }
    func addTopLineToTabBar() {
        let lineHeight: CGFloat = 0.7
        let lineColor: UIColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        let path = UIBezierPath()
        let centerWidth = tabBar.bounds.width / 2
        let curveHeight: CGFloat = 25

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: centerWidth - 40, y: 0))
        path.addQuadCurve(to: CGPoint(x: centerWidth + 40, y: 0), controlPoint: CGPoint(x: centerWidth, y: -curveHeight))
        path.addLine(to: CGPoint(x: tabBar.bounds.width, y: 0))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineHeight
        
        tabBar.layer.addSublayer(shapeLayer)
    }
    @objc func centerButtonTapped() {
        selectedIndex = 2
    }
}

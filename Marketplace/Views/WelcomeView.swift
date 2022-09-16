//
//  WelcomeView.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 23/08/2022.
//

import UIKit
import SnapKit

class WelcomeView: UIView {

    private let launchingImage =  UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureWelcomeView()
        startLaunchingAnimation(view: launchingImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.frame = bounds
        self.backgroundColor = .systemBackground
    }
    
    private func configureWelcomeView() {
        let widthConstant: CGFloat = 245
        let heightConstant: CGFloat = 260
        
        launchingImage.image = Images.logoImage
        launchingImage.contentMode = .scaleAspectFill
        self.addSubview(launchingImage)
        
        
        launchingImage.snp.makeConstraints { make in
            make.height.equalTo(heightConstant)
            make.width.equalTo(widthConstant)
            make.centerX.centerY.equalTo(self)
        }
    }
    
    private func startLaunchingAnimation(view: UIImageView) {
        UIView.animate(withDuration: 1, delay: 0, animations: {
            view.transform = CGAffineTransform(translationX: 0, y: -600)
        }) { _ in
            UIView.transition(with: self, duration: 1, animations: {
                self.alpha = 0
            })
        }
    }
}

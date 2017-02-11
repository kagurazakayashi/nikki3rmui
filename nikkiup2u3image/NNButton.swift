//
//  NNButton.swift
//  nikkiup2u3image
//
//  Created by 神楽坂雅詩 on 2017/2/11.
//  Copyright © 2017年 KagurazakaYashi. All rights reserved.
//

import UIKit

class NNButton: UIButton {

    func 创建UI(按钮名称:String) {
        let gradientColors = [UIColor(red: 1.0, green: 0.66666667, blue: 0.67843137, alpha: 1.0), UIColor(red: 1.0, green: 0.4745098, blue: 0.45098039, alpha: 1.0)]
        self.backgroundColor = UIColor(patternImage: UIImage(gradientColors: gradientColors, size: self.frame.size)!)
        self.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.setTitleColor(UIColor.darkGray, for: UIControlState.highlighted)
//        self.setTitleShadowColor(UIColor.gray, for: UIControlState.normal)
//        self.titleLabel?.shadowOffset = CGSize(width: -1, height: 1)
        self.setTitle(按钮名称, for: UIControlState.normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.layer.cornerRadius = self.frame.size.height * 0.5
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
//        self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
//        self.layer.shadowRadius = 3.0;
//        self.layer.shadowColor = UIColor(red: 0.70980392, green: 0.57254902, blue: 0.61176471, alpha: 1.0).cgColor
//        self.layer.shadowOpacity = 0
    }
    
}

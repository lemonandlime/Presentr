//
//  GradientView.swift
//  Presentr
//
//  Created by Karl Söderberg on 05/09/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {
    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
    @IBInspectable var topColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    let gradient: CAGradientLayer = CAGradientLayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    private func setupGradient() {
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        layer.insertSublayer(gradient, at: 0)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        gradient.frame = bounds
    }
    
}



//
//  Slider.swift
//  Fader_Example
//
//  Created by ryohey on 2018/10/05.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

@IBDesignable
class Slider: UIView {
    // 0 to 1
    @IBInspectable
    public var value: Float = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    public var valueChanged: ((Float) -> Void)?

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        ctx.addRect(CGRect(x: 0,
                           y: 0,
                           width: CGFloat(Float(rect.width) * value),
                           height: rect.height))
        ctx.setFillColor(tintColor.cgColor)
        ctx.fillPath()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        handleTouches(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        handleTouches(touches)
    }

    private func handleTouches(_ touches: Set<UITouch>) {
        guard let loc = touches.first?.location(in: self) else {
            return
        }
        value = Float(loc.x) / Float(frame.width)
        valueChanged?(value)
    }
}

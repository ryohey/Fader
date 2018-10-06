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
    @IBInspectable
    public var value: Float = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    public var minValue: Float = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    public var maxValue: Float = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    public var valueChanged: ((Float) -> Void)?

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        let pos = (value - minValue) / (maxValue - minValue)
        ctx.addRect(CGRect(x: 0,
                           y: 0,
                           width: CGFloat(Float(rect.width) * pos),
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
        let s = max(0.0, min(1.0, Float(loc.x) / Float(frame.width)))
        value = minValue + s * (maxValue - minValue)
        valueChanged?(value)
    }
}

import UIKit

@IBDesignable
public class Switch: UIView {
    @IBInspectable
    public var value: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    public var valueChanged: ((Bool) -> Void)?

    override public func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }

        // draw container
        do {
            let path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height / 2.0)

            ctx.addPath(path.cgPath)
            ctx.setFillColor((value ? tintColor : UIColor.gray).cgColor)
            ctx.fillPath()
        }

        // draw thumb
        do {
            let margin: CGFloat = 3
            let size = rect.height - margin * 2.0

            ctx.addEllipse(in: CGRect(
                x: value ? rect.width - size - margin : margin,
                y: margin,
                width: size,
                height: size))
            ctx.setFillColor(UIColor.white.cgColor)
            ctx.fillPath()
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        value = !value
    }
}

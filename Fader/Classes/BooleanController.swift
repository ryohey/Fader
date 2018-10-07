import UIKit

@IBDesignable
public class BooleanController: ControllerView, Controller {
    public typealias ValueType = Bool

    @IBInspectable
    public var value: ValueType = false {
        didSet {
            applyValue()
        }
    }

    public var valueChanged: ((ValueType) -> Void)?
    
    public override var tintColor: UIColor! {
        didSet {
            button.tintColor = tintColor
        }
    }

    private let button = Switch(frame: CGRect.zero)

    override func initialize() {
        super.initialize()

        button.backgroundColor = UIColor.clear

        addSubview(mark)
        addSubview(label)
        addSubview(button)

        button.valueChanged = {
            self.value = $0
            self.valueChanged?($0)
        }

        applyValue()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let height = frame.height - Margin * 2.0

        button.frame = CGRect(x: label.frame.maxX + Margin,
                              y: Margin,
                              width: height * 1.8,
                              height: height)
    }

    private func applyValue() {
        button.value = value
    }
}

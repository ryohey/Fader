import UIKit

@IBDesignable
public class BooleanController: UIView, Controller {
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
            mark.backgroundColor = tintColor
            button.tintColor = tintColor
        }
    }

    private let mark = UIView(frame: CGRect.zero)
    private let label = UILabel(frame: CGRect.zero)
    private let button = Switch(frame: CGRect.zero)

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        backgroundColor = UIColor.black
        label.text = "Label"
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)

        mark.backgroundColor = tintColor
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
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

        let margin: CGFloat = 8.0
        let markWidth: CGFloat = 5
        let contentWidth = frame.width - markWidth - margin * 2
        let labelWidth = contentWidth / 3 - margin * 2
        let height = frame.height - margin * 2.0

        mark.frame = CGRect(x: 0, y: 0, width: markWidth, height: frame.height)
        label.frame = CGRect(x: mark.frame.maxX + margin, y: margin, width: labelWidth, height: height)
        button.frame = CGRect(x: label.frame.maxX + margin, y: margin, width: height * 1.8, height: height)
    }

    private func applyValue() {
        button.value = value
    }
}

import UIKit

@IBDesignable
public class SliderRow: UIView, Row {
    public typealias ValueType = Float

    @IBInspectable
    public var value: ValueType = 0.5 {
        didSet {
            applyValue()
        }
    }

    public override var tintColor: UIColor! {
        didSet {
            slider.tintColor = tintColor
            mark.backgroundColor = tintColor
        }
    }

    private let mark = UIView(frame: CGRect.zero)
    private let label = UILabel(frame: CGRect.zero)
    private let slider = Slider(frame: CGRect.zero)
    private let textField = UITextField(frame: CGRect.zero)

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

        mark.backgroundColor = tintColor
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        slider.backgroundColor = UIColor.init(white: 1, alpha: 0.2)
        textField.backgroundColor = UIColor.init(white: 1, alpha: 0.2)
        textField.textColor = UIColor.white
        textField.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)

        addSubview(mark)
        addSubview(label)
        addSubview(slider)
        addSubview(textField)

        slider.valueChanged = { self.value = $0 }
        textField.keyboardType = .decimalPad
        configureTextFieldAccessory()

        applyValue()
    }

    private func configureTextFieldAccessory() {
        let toolbar = UIToolbar()

        toolbar.barStyle = .blackTranslucent
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.didPushCancel)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.didPushDone))
        ]

        toolbar.sizeToFit()

        textField.inputAccessoryView = toolbar
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let margin: CGFloat = 8.0
        let markWidth: CGFloat = 5
        let contentWidth = frame.width - markWidth - margin * 2
        let labelWidth = contentWidth / 3 - margin * 2
        let textFieldWidth = contentWidth / 4 - margin * 2
        let sliderWidth = contentWidth - labelWidth - textFieldWidth - margin * 2
        let height = frame.height - margin * 2.0

        mark.frame = CGRect(x: 0, y: 0, width: markWidth, height: frame.height)
        label.frame = CGRect(x: mark.frame.maxX + margin, y: margin, width: labelWidth, height: height)
        slider.frame = CGRect(x: label.frame.maxX + margin, y: margin, width: sliderWidth, height: height)
        textField.frame = CGRect(x: slider.frame.maxX + margin, y: margin, width: textFieldWidth, height: height)
    }

    private func applyValue() {
        slider.value = value
        textField.text = "\(value)"
    }

    @objc private func didPushDone() {
        if let text = textField.text, let v = Float(text) {
            value = v
            textField.resignFirstResponder()
        } else {
            applyValue()
        }
    }

    @objc private func didPushCancel() {
        applyValue()
        textField.resignFirstResponder()
    }
}

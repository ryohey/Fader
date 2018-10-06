import UIKit

@IBDesignable
public class NumberControllerSlider<T>: UIView, Controller where T: FloatConvertible {
    public typealias ValueType = T

    public var value: ValueType = .init(0) {
        didSet {
            applyValue()
        }
    }

    public var minValue: ValueType = .init(0.0) {
        didSet {
            slider.minValue = minValue.asFloat
            value = max(minValue, value)
        }
    }

    public var maxValue: ValueType = .init(1.0) {
        didSet {
            slider.maxValue = maxValue.asFloat
            value = min(maxValue, value)
        }
    }

    public var valueChanged: ((ValueType) -> Void)?

    public override var tintColor: UIColor! {
        didSet {
            slider.tintColor = tintColor
            mark.backgroundColor = tintColor
        }
    }

    private let mark = UIView(frame: .zero)
    private let label = UILabel(frame: .zero)
    private let slider = Slider(frame: .zero)
    private let textField = UITextField(frame: .zero)

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
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: UIFont.smallSystemFontSize)
        slider.backgroundColor = UIColor(white: 1, alpha: 0.2)
        textField.backgroundColor = UIColor(white: 1, alpha: 0.2)
        textField.textColor = .white
        textField.font = .systemFont(ofSize: UIFont.smallSystemFontSize)

        addSubview(mark)
        addSubview(label)
        addSubview(slider)
        addSubview(textField)

        slider.valueChanged = {
            let v = T.init($0)
            self.value = v
            self.valueChanged?(v)
        }
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
        let v = value.asFloat
        slider.value = v
        textField.text = "\(v)"
    }

    @objc private func didPushDone() {
        if let text = textField.text,
            let valueFloat = Float(text) {
            let valueT = T.init(valueFloat)
            let adjustedValue = min(maxValue, max(minValue, valueT))
            value = adjustedValue
            valueChanged?(value)
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

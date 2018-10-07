import UIKit

@IBDesignable
public class NumberControllerSlider<T>: ControllerView, Controller where T: FloatConvertible {
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
        }
    }

    private let slider = Slider(frame: .zero)
    private let textField = UITextField(frame: .zero)

    override func initialize() {
        super.initialize()

        slider.backgroundColor = UIColor(white: 1, alpha: 0.2)
        slider.valueChanged = {
            let v = T.init($0)
            self.value = v
            self.valueChanged?(v)
        }
        addSubview(slider)

        textField.backgroundColor = UIColor(white: 1, alpha: 0.2)
        textField.textColor = .white
        textField.font = .systemFont(ofSize: UIFont.smallSystemFontSize)
        textField.keyboardType = .decimalPad
        textField.inputAccessoryView = createInputToolbar()
        addSubview(textField)

        applyValue()
    }

    private func createInputToolbar() -> UIToolbar {
        let toolbar = UIToolbar()

        toolbar.barStyle = .blackTranslucent
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.didPushCancel)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.didPushDone))
        ]

        toolbar.sizeToFit()

        return toolbar
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let contentWidth = frame.width - label.frame.maxX - Margin * 2
        let textFieldWidth = contentWidth / 4 - Margin
        let sliderWidth = contentWidth - textFieldWidth - Margin
        let height = frame.height - Margin * 2.0

        slider.frame = CGRect(x: label.frame.maxX + Margin,
                              y: Margin,
                              width: sliderWidth,
                              height: height)

        textField.frame = CGRect(x: slider.frame.maxX + Margin,
                                 y: Margin,
                                 width: textFieldWidth,
                                 height: height)
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

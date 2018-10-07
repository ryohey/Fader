import UIKit

@IBDesignable
public class StringController: ControllerView, Controller {
    public typealias ValueType = String?

    @IBInspectable
    public var value: ValueType = "" {
        didSet {
            applyValue()
        }
    }

    public var valueChanged: ((ValueType) -> Void)?

    private let textField = UITextField(frame: CGRect.zero)

    override func initialize() {
        super.initialize()

        textField.backgroundColor = UIColor.init(white: 1, alpha: 0.2)
        textField.textColor = UIColor.white
        textField.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        textField.keyboardType = .default
        textField.delegate = self
        addSubview(textField)
        
        tintColor = UIColor(red: 0.118, green: 0.827, blue: 0.435, alpha: 1)

        applyValue()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let textFieldWidth = frame.width - label.frame.maxX - Margin * 2
        let height = frame.height - Margin * 2.0

        textField.frame = CGRect(x: label.frame.maxX + Margin,
                                 y: Margin,
                                 width: textFieldWidth,
                                 height: height)
    }

    private func applyValue() {
        textField.text = value
    }
}

extension StringController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            value = textField.text ?? ""
            valueChanged?(value)
            return false
        }
        return true
    }
}

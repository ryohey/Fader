import UIKit

@IBDesignable
public class TextRow: UIView, Row {
    public typealias ValueType = String

    @IBInspectable
    public var value: ValueType = "" {
        didSet {
            applyValue()
        }
    }

    public override var tintColor: UIColor! {
        didSet {
            mark.backgroundColor = tintColor
        }
    }

    private let mark = UIView(frame: CGRect.zero)
    private let label = UILabel(frame: CGRect.zero)
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
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)

        mark.backgroundColor = tintColor
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        textField.backgroundColor = UIColor.init(white: 1, alpha: 0.2)
        textField.textColor = UIColor.white
        textField.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)

        addSubview(mark)
        addSubview(label)
        addSubview(textField)

        textField.keyboardType = .default
        textField.delegate = self

        applyValue()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let margin: CGFloat = 8.0
        let markWidth: CGFloat = 5
        let contentWidth = frame.width - markWidth - margin * 2
        let labelWidth = contentWidth / 3 - margin * 2
        let textFieldWidth = contentWidth - labelWidth - margin
        let height = frame.height - margin * 2.0

        mark.frame = CGRect(x: 0, y: 0, width: markWidth, height: frame.height)
        label.frame = CGRect(x: mark.frame.maxX + margin, y: margin, width: labelWidth, height: height)
        textField.frame = CGRect(x: label.frame.maxX + margin, y: margin, width: textFieldWidth, height: height)
    }

    private func applyValue() {
        textField.text = value
    }
}

extension TextRow: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        return true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
    }
}

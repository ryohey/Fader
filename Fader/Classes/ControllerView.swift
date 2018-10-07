import UIKit

public class ControllerView: UIView {
    let Margin: CGFloat = 8
    let mark = UIView(frame: CGRect.zero)
    let label = UILabel(frame: CGRect.zero)

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    func initialize() {
        backgroundColor = UIColor.black

        label.text = "Label"
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear

        mark.backgroundColor = tintColor

        addSubview(mark)
        addSubview(label)
    }

    public var labelText: String = "" {
        didSet {
            label.text = labelText
        }
    }

    public override var tintColor: UIColor! {
        didSet {
            mark.backgroundColor = tintColor
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let markWidth: CGFloat = 5
        let contentWidth = frame.width - markWidth - Margin * 2
        let labelWidth = contentWidth / 3 - Margin * 2
        let height = frame.height - Margin * 2.0

        mark.frame = CGRect(x: 0, y: 0, width: markWidth, height: frame.height)
        label.frame = CGRect(x: mark.frame.maxX + Margin, y: Margin, width: labelWidth, height: height)
    }
}

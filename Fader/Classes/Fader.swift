import UIKit

struct ControllerTarget<T: AnyObject> {
    var view: UIView
    weak var target: T?
}

private let ControllerHeight: CGFloat = 44
private let SeparatorHeight: CGFloat = 0.5

@IBDesignable
public class Fader: UIStackView {
    // controller, target pair
    private var controllers = [ControllerTarget<AnyObject>]()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        axis = .vertical
        alignment = .fill

        setupCloseButton()
    }

    private func setupCloseButton() {
        addArrangedSubview(createSeparator())

        let button = UIButton(type: .custom)
        button.backgroundColor = .black
        button.setTitle("Close Controls", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        addArrangedSubview(button)
        button.heightAnchor.constraint(equalToConstant: ControllerHeight).isActive = true
    }

    private func addContent(_ view: UIView) {
        // below close button
        insertArrangedSubview(view, at: arrangedSubviews.count - 2)
    }

    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = UIColor(white: 0.3, alpha: 1)
        separator.heightAnchor.constraint(equalToConstant: SeparatorHeight).isActive = true
        return separator
    }

    public func add<T, S>(target: T,
                          keyPath: WritableKeyPath<T, S>,
                          minValue: S = .init(0.0),
                          maxValue: S = .init(1.0)) where T: AnyObject, S: FloatConvertible {
        let ctrl = NumberControllerSlider<S>(frame: .zero)
        ctrl.minValue = minValue
        ctrl.maxValue = maxValue
        addController(target: target,
                      keyPath: keyPath,
                      controller: AnyController(ctrl),
                      view: ctrl)
    }

    public func add<T>(target: T, keyPath: WritableKeyPath<T, String>) where T: AnyObject {
        let ctrl = StringController(frame: .zero)
        addController(target: target,
                      keyPath: keyPath,
                      controller: AnyController(ctrl),
                      view: ctrl)
    }

    public func add<T>(target: T, keyPath: WritableKeyPath<T, Bool>) where T: AnyObject {
        let ctrl = BooleanController(frame: .zero)
        addController(target: target,
                      keyPath: keyPath,
                      controller: AnyController(ctrl),
                      view: ctrl)
    }

    private func addController<T, S>(target: T,
                                    keyPath: WritableKeyPath<T, S>,
                                    controller: AnyController<S>,
                                    view: UIView) where T: AnyObject {
        addControllerView(view)

        controllers.append(ControllerTarget(view: view, target: target))

        let keyPathName = target is NSObject ? NSExpression(forKeyPath: keyPath).keyPath : "unknown"

        controller.labelText = keyPathName
        controller.value = target[keyPath: keyPath]
        controller.valueChanged = { [weak self] (value) in
            if var target = self?.controllers.first(where: { $0.view == view })?.target as? T {
                target[keyPath: keyPath] = value
            } else {
                print("warn: target is nil")
            }
        }
    }

    private func addControllerView(_ controller: UIView) {
        let firstController = controllers.first?.view

        if firstController != nil {
            addContent(createSeparator())
        }

        addContent(controller)
        controller.heightAnchor.constraint(equalToConstant: ControllerHeight).isActive = true
    }

    override public var intrinsicContentSize: CGSize {
        let count = CGFloat(controllers.count)
        let h = count * ControllerHeight + (count - 1.0) * SeparatorHeight
        return CGSize(width: 200, height: h)
    }
}

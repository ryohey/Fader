import UIKit

struct ControllerTarget<T: AnyObject> {
    var view: UIView
    weak var target: T?
}

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
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    private func addContent(_ view: UIView) {
        // below close button
        insertArrangedSubview(view, at: arrangedSubviews.count - 2)
    }

    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = UIColor(white: 0.3, alpha: 1)
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return separator
    }

    public func add<T, S>(target: inout T,
                          keyPath: WritableKeyPath<T, S>,
                          minValue: S = .init(0.0),
                          maxValue: S = .init(1.0)) where T: AnyObject, S: FloatConvertible {
        let ctrl = NumberControllerSlider<S>(frame: .zero)
        ctrl.minValue = minValue
        ctrl.maxValue = maxValue
        addController(target: &target,
                      keyPath: keyPath,
                      controller: AnyController(ctrl),
                      view: ctrl)
    }

    public func add<T>(target: inout T, keyPath: WritableKeyPath<T, String>) where T: AnyObject {
        let ctrl = StringController(frame: .zero)
        addController(target: &target,
                      keyPath: keyPath,
                      controller: AnyController(ctrl),
                      view: ctrl)
    }

    public func add<T>(target: inout T, keyPath: WritableKeyPath<T, Bool>) where T: AnyObject {
        let ctrl = BooleanController(frame: .zero)
        addController(target: &target,
                      keyPath: keyPath,
                      controller: AnyController(ctrl),
                      view: ctrl)
    }

    private func addController<T, S>(target: inout T,
                                    keyPath: WritableKeyPath<T, S>,
                                    controller: AnyController<S>,
                                    view: UIView) where T: AnyObject {
        addControllerView(view)

        controllers.append(ControllerTarget(view: view, target: target))

        controller.value = target[keyPath: keyPath]
        controller.valueChanged = { [weak self] (value) in
            // Since inout parameter can not be captured, it is obtained from a tuple
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

        if let first = firstController {
            controller.heightAnchor.constraint(equalTo: first.heightAnchor).isActive = true
        }
    }
}

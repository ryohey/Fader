import UIKit

private let ControllerHeight: CGFloat = 44

@IBDesignable
public class Fader: UIStackView {
    // controller, target pair
    private var controllers = [UIView]()
    private let closeButton = UIButton(type: .custom)

    public var isOpen: Bool = true {
        didSet {
            fold()
        }
    }

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
        addArrangedSubview(closeButton)

        closeButton.backgroundColor = .black
        closeButton.setTitle("Close Controls", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        closeButton.heightAnchor.constraint(equalToConstant: ControllerHeight).isActive = true

        closeButton.addTarget(self, action: #selector(self.didPushCloseButton), for: .touchUpInside)
    }

    @objc private func didPushCloseButton() {
        isOpen = !isOpen
    }

    private func addController(_ controller: UIView) {
        controllers.append(controller)
        // insert before close button
        insertArrangedSubview(controller, at: arrangedSubviews.count - 1)
        controller.heightAnchor.constraint(equalToConstant: ControllerHeight).isActive = true
    }

    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 200,
                      height: CGFloat(controllers.count) * ControllerHeight)
    }

    private func fold() {
        closeButton.setTitle(isOpen ? "Close Controls" : "Open Controls", for: .normal)

        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.curveEaseOut],
                       animations: {
                        for ctrl in self.controllers {
                            ctrl.isHidden = !self.isOpen
                            ctrl.alpha = self.isOpen ? 1 : 0
                        }
        },
                       completion: nil)
    }
}

// MARK: - KeyPath support

extension Fader {
    public func add<T, S>(target: T,
                          keyPath: WritableKeyPath<T, S>,
                          minValue: S = .init(0.0),
                          maxValue: S = .init(1.0),
                          label: String? = nil) where T: AnyObject, S: FloatConvertible {
        var view = NumberControllerSlider<S>(frame: .zero)
        view.minValue = minValue
        view.maxValue = maxValue
        view.bind(to: target, keyPath: keyPath, propName: nil)
        addController(view)
    }

    public func add<T>(target: T,
                       keyPath: WritableKeyPath<T, String?>,
                       label: String? = nil) where T: AnyObject {
        var view = StringController(frame: .zero)
        view.bind(to: target, keyPath: keyPath, propName: label)
        addController(view)
    }

    public func add<T>(target: T,
                       keyPath: WritableKeyPath<T, Bool>,
                       label: String? = nil) where T: AnyObject {
        var view = BooleanController(frame: .zero)
        view.bind(to: target, keyPath: keyPath, propName: label)
        addController(view)
    }
}

// MARK: - Callback support

extension Fader {
    public func add<T>(label: String,
                       minValue: T = .init(0.0),
                       maxValue: T = .init(1.0),
                       initialValue: T = .init(0.0),
                       callback: @escaping (T) -> Void) where T: FloatConvertible {
        var view = NumberControllerSlider<T>(frame: .zero)
        view.bind(to: callback, propName: label, initialValue: initialValue)
        addController(view)
    }

    public func add(label: String,
                    initialValue: String = "",
                    callback: @escaping (String?) -> Void) {
        var view = StringController(frame: .zero)
        view.bind(to: callback, propName: label, initialValue: initialValue)
        addController(view)
    }

    public func add(label: String,
                    initialValue: Bool = false,
                    callback: @escaping (Bool) -> Void) {
        var view = BooleanController(frame: .zero)
        view.bind(to: callback, propName: label, initialValue: initialValue)
        addController(view)
    }
}

import UIKit

private struct Target {
    let target: Any
    let keyPath: KeyPath<Any, Any>
    let minValue: Float
    let maxValue: Float
    weak var view: UIView?
}

public class Fader: UIView {
    private var targets = [Target]()

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func add(_ target: Any,
                    forKey keyPath: KeyPath<Any, Any>,
                    minValue: Float = 0,
                    maxValue: Float = 1) {

        let slider = UISlider(frame: CGRect(x: 0, y: 0, width: 200, height: 44))

        targets.append(Target(target: target,
                              keyPath: keyPath,
                              minValue: minValue,
                              maxValue: maxValue,
                              view: slider))

        addSubview(slider)
    }
}

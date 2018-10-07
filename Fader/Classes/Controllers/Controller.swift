import Foundation

public protocol Controller {
    associatedtype ValueType
    var value: ValueType { get set }
    var valueChanged: ((ValueType) -> Void)? { get set }
    var labelText: String { get set }
}

private func updater<T, ValueType>(target: T,
                           keyPath: WritableKeyPath<T, ValueType>) -> (ValueType) -> Void where T: AnyObject {
    return { [weak target] (value) in
        target?[keyPath: keyPath] = value
    }
}

extension Controller {
    mutating func bind<T>(to target: T,
                          keyPath: WritableKeyPath<T, ValueType>,
                          propName: String?) where T: AnyObject {
        let keyPathName = target is NSObject ? NSExpression(forKeyPath: keyPath).keyPath : nil
        labelText = propName ?? keyPathName ?? "unknown"
        value = target[keyPath: keyPath]
        valueChanged = updater(target: target, keyPath: keyPath)
    }

    mutating func bind(to callback: @escaping (ValueType) -> Void,
                       propName: String,
                       initialValue: ValueType) {
        labelText = propName
        value = initialValue
        valueChanged = callback
    }
}

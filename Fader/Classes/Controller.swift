import Foundation

public protocol Controller {
    associatedtype ValueType
    var value: ValueType { get set }
    var valueChanged: ((ValueType) -> Void)? { get set }
    var labelText: String { get set }
}

public class AnyController<ValueType>: Controller {
    private let valueGetter: () -> ValueType
    private let valueSetter: (ValueType) -> Void
    private let valueChangedGetter: () -> ((ValueType) -> Void)?
    private let valueChangedSetter: (((ValueType) -> Void)?) -> Void
    private let labelTextGetter: () -> String
    private let labelTextSetter: (String) -> Void

    init<T: Controller>(_ base: T)
        where T.ValueType == ValueType
    {
        var mbase = base
        valueGetter = { base.value }
        valueSetter = { mbase.value = $0 }
        valueChangedGetter = { base.valueChanged }
        valueChangedSetter = { mbase.valueChanged = $0 }
        labelTextGetter = { base.labelText }
        labelTextSetter = { mbase.labelText = $0 }
    }

    public var value: ValueType {
        get { return valueGetter() }
        set { valueSetter(newValue) }
    }

    public var valueChanged: ((ValueType) -> Void)? {
        get { return valueChangedGetter() }
        set { valueChangedSetter(newValue) }
    }

    public var labelText: String {
        get { return labelTextGetter() }
        set { labelTextSetter(newValue) }
    }

}

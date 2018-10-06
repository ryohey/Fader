import UIKit

public protocol FloatConvertible: Comparable {
    init(_ value: Float)
    var asFloat: Float { get }
}

extension Double: FloatConvertible {
    public var asFloat: Float { return Float(self) }
}

extension Float: FloatConvertible {
    public var asFloat: Float { return Float(self) }
}

extension CGFloat: FloatConvertible {
    public var asFloat: Float { return Float(self) }
}

extension Int: FloatConvertible {
    public var asFloat: Float { return Float(self) }
}
extension Int8: FloatConvertible {
    public var asFloat: Float { return Float(self) }
}

extension Int16: FloatConvertible {
    public var asFloat: Float { return Float(self) }
}

extension Int32: FloatConvertible {
    public var asFloat: Float { return Float(self) }
}

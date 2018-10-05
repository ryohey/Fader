import UIKit

public protocol Row {
    associatedtype ValueType
    var value: ValueType { get set }
}

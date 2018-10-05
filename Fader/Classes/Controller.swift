import UIKit

public protocol Controller {
    associatedtype ValueType
    var value: ValueType { get set }
}

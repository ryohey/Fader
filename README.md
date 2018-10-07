# Fader

[![CI Status](https://img.shields.io/travis/ryohey/Fader.svg?style=flat)](https://travis-ci.org/ryohey/Fader)
[![Version](https://img.shields.io/cocoapods/v/Fader.svg?style=flat)](https://cocoapods.org/pods/Fader)
[![License](https://img.shields.io/cocoapods/l/Fader.svg?style=flat)](https://cocoapods.org/pods/Fader)
[![Platform](https://img.shields.io/cocoapods/p/Fader.svg?style=flat)](https://cocoapods.org/pods/Fader)

![many faders](https://user-images.githubusercontent.com/5355966/46582106-f5006780-ca7c-11e8-88bc-d4b227d36612.jpg)

![video](https://user-images.githubusercontent.com/5355966/46582006-e5345380-ca7b-11e8-9310-1e549d60938d.gif)

Fader is a lightweight controller library for Swift heavily inspired by dat.gui.

## Code Example

```swift
let fader = Fader(frame: .zero)

fader.add(target: particle,
          keyPath: \SCNParticleSystem.birthRate,
          minValue: 0.0,
          maxValue: 1000.0)
```

By the grammar of the new keypath of Swift 4, we can describe it type-safely shortly.

## Usage

![image](https://user-images.githubusercontent.com/5355966/46582125-37c23f80-ca7d-11e8-86af-9262426752a0.png)

1. Add Fader view to your screen
1. Add x, y, width constraints
1. Add codes to specify properties to modify

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

Fader is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Fader'
```

## KeyPath API

Since pure swift class can not get the name from KeyPath, use the label parameter.

### Number

```swift
fader.add(target: car,
          keyPath: \Car.speed,
          minValue: 0.0,
          maxValue: 120.0)
```

### Boolean

```swift
fader.add(target: door,
          keyPath: \Door.isClosed)
```

### String

```swift
fader.add(target: label,
          keyPath: \UILabel.text)
```

## Callback API

Specify initialValue to set the initial value with Callback API.

### Number

```swift
fader.add(label: "strength", minValue: 0.0, maxValue: 100) { (value: Double) in
    self.attackStrength = value
}
```

### Boolean

```swift
fader.add(label: "on off") { (isOn: Bool) in
    self.switch.isOn = isOn
}
```

### String

```swift
fader.add(label: "name") { (str: String?) in
    self.nameLabel.text = str
}
```

## Author

ryohey, info@codingcafe.jp

## License

Fader is available under the MIT license. See the LICENSE file for more info.

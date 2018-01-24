# ArrowKit

A helper framework to write arrows for [Archery](https://github.com/vknabel/Archery) in Swift.

```swift
import ArrowKit

struct YourArrow: Arrow {
    let name: String

    func fire(archerfile arrowFile: ArrowKit.Archerfile, arguments: [String]) throws {
        print("Hello \(name)!")
        if !arguments.isEmpty {
            print("Your arguments are:")
            for arg in arguments {
                print(" \(arg)")
            }
        }
    }
}

YourArrow.fire()
```

## Installation

Using the Swift Package Manager
```swift
.package(url: "https://github.com/vknabel/ArrowKit.git", from: "0.2.0"),
```

## Contributors
* Valentin Knabel, [@vknabel](https://github.com/vknabel), dev@vknabel.com

## License
Archery is available under the [MIT](./master/LICENSE) license.

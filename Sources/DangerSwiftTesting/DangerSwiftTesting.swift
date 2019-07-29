public struct DangerSwiftTesting {
    public var text = "Hello, World!"
    public init() {}
    public init(text: String) {
        self.text = text
    }
}
public protocol HasText {
    var text: String { get set }
}

extension DangerSwiftTesting: HasText {}

extension DefaultStringInterpolation {
    mutating func appendInterpolation(_ value: HasText) {
        self.appendInterpolation(value.text)
    }
}

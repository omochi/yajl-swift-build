import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(yajl_swiftpmTests.allTests),
    ]
}
#endif
import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(PerfectCSV_SwiftTests.allTests),
    ]
}
#endif

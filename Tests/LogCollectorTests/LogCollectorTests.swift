import XCTest
@testable import LogCollector

final class LogCollectorTests: XCTestCase {
    
    func testStoreBatchSizeLogsAndInvokeWoker() {
        innerTestStoreLogsAndInvokeWorker(logSize: 5, invokeCount: 2, assetTimeout: 3, line: #line)
    }
    
    func testStoreOverBatchSizeLogsAndInvokeWorker() {
        innerTestStoreLogsAndInvokeWorker(logSize: 8, invokeCount:3, assetTimeout: 5, line: #line)
    }
    
    func innerTestStoreLogsAndInvokeWorker(logSize: Int, invokeCount: Int, assetTimeout: Double, line: UInt) {
        var processedLogs: [TestLogData] = []
        let exp = expectation(description: "worker invoked")
        exp.assertForOverFulfill = false
        exp.expectedFulfillmentCount = invokeCount
        
        let logCollector = LogCollector<TestLogData>(workerInterval: 2) { logs in
            DispatchQueue.main.async {
                processedLogs.append(contentsOf: logs)
                exp.fulfill()
            }
        }
        
        (1...logSize).forEach { index in
            let newLog = TestLogData(message: "Test log \(index)")
            logCollector.storeLog(log: newLog)
        }
        
        XCTAssert(processedLogs.isEmpty)
        
        if XCTWaiter.wait(for: [exp], timeout: assetTimeout) == .timedOut {
            XCTFail("worker not invoked", line: line)
        }
        XCTAssertEqual(processedLogs.count, logSize, line: line)
    }
}

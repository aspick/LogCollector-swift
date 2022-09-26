//
//  BufferTests.swift
//  
//
//  Created by Yugo TERADA on 2022/09/17.
//

import XCTest
@testable import LogCollector

final class BufferTests: XCTestCase {
    func testPushSingleLog() {
        let buffer = Buffer<TestLogData>()
        let data1 = TestLogData(message: "Test")
        
        buffer.pushLogs([data1])
        
        XCTAssertEqual(buffer.orderdLogs, [data1])
    }
    
    func testPushMultipleLogs() {
        let buffer = Buffer<TestLogData>()
        let data1 = TestLogData(message: "Test1")
        let data2 = TestLogData(message: "Test2")
        
        buffer.pushLogs([data1])
        buffer.pushLogs([data2])
        
        XCTAssertEqual(buffer.orderdLogs, [data1, data2])
    }
    
    func testOrderdLogsWithPushRevertOrder() {
        let buffer = Buffer<TestLogData>()
        let data1 = TestLogData(message: "Test1", time: Date())
        let data2 = TestLogData(message: "Test2", time: Date().advanced(by: 10))
        
        buffer.pushLogs([data2, data1])
        
        XCTAssertEqual(buffer.orderdLogs, [data1, data2])
    }
    
    func testOrderdLogsWithPushRegulerOrder() {
        let buffer = Buffer<TestLogData>()
        let data1 = TestLogData(message: "Test", time: Date())
        let data2 = TestLogData(message: "Test", time: Date().advanced(by: 10))
        
        buffer.pushLogs([data1, data2])
        
        XCTAssertEqual(buffer.orderdLogs, [data1, data2])
    }
    
    func testPopLogs() {
        let buffer = Buffer<TestLogData>()
        let dataList: [TestLogData] = (1...10).map { index in
            TestLogData(message: "Test \(index)")
        }
        buffer.pushLogs(dataList)
        
        let popedLogs = buffer.popLogs()
        
        XCTAssertEqual(popedLogs.count, 5)
        XCTAssertEqual(popedLogs, Array(dataList[0..<5]))
        XCTAssertEqual(buffer.orderdLogs.count, 5)
        XCTAssertEqual(buffer.orderdLogs, Array(dataList[5..<10]))
    }
    
    func testPopLogsWithSmallBatchSize() {
        let buffer = Buffer<TestLogData>(batchSize: 2)
        let dataList: [TestLogData] = (1...10).map { index in
            TestLogData(message: "Test \(index)")
        }
        buffer.pushLogs(dataList)
        
        let popedLogs = buffer.popLogs()
        
        XCTAssertEqual(popedLogs.count, 2)
        XCTAssertEqual(popedLogs, Array(dataList[0..<2]))
        XCTAssertEqual(buffer.orderdLogs.count, 8)
        XCTAssertEqual(buffer.orderdLogs, Array(dataList[2..<10]))
    }
    
    func testIsEmpty() {
        let buffer = Buffer<TestLogData>()
        let data = TestLogData(message: "Test")
        
        XCTAssertEqual(buffer.isEmpty, true)
        
        buffer.pushLogs([data])
        
        XCTAssertEqual(buffer.isEmpty, false)
        
        _ = buffer.popLogs()
        
        XCTAssertEqual(buffer.isEmpty, true)
    }
}

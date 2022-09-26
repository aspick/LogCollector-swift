//
//  TestLogData.swift
//  
//
//  Created by Yugo TERADA on 2022/09/19.
//

import Foundation
@testable import LogCollector

class TestLogData: LogData, Equatable {
    let id: String
    let time: Date
    let message: String
    
    init(message: String, time: Date = Date()) {
        self.id = UUID().uuidString
        self.time = time
        self.message = message
    }
    
    static func == (lhs: TestLogData, rhs: TestLogData) -> Bool {
        lhs.id == rhs.id
    }
    
    func payload() -> Dictionary<String, Any> {
        [
            "id": self.id,
            "time": ISO8601DateFormatter().string(from: self.time),
            "message": self.message
        ]
    }
    
    func orderKey() -> Double {
        time.timeIntervalSinceReferenceDate
    }
}

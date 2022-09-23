//
//  Buffer.swift
//  
//
//  Created by Yugo TERADA on 2022/09/17.
//

import Foundation

/// Buffer of log data class
class Buffer<T: LogData & Equatable> {
    var store: [T] = []
    var batchSize: Int!
    let lock = NSLock()
    
    
    /// Initialize Buffer clss
    /// - Parameter batchSize: logs count once `popLogs` method call
    init(batchSize: Int = 5) {
        self.batchSize = batchSize
    }
        
    /// stored log orderd by `orderKey` attribute asc
    var orderdLogs: [T] {
        store.sorted { a, b in
            a.orderKey() < b.orderKey()
        }
    }
    
    /// pop stored logs
    /// - Returns: poped logs
    func popLogs() -> [T] {
        defer { lock.unlock() }
        lock.lock()
        
        let logs = orderdLogs.prefix(batchSize)
        store.removeAll { log in
            logs.contains { $0 == log }
        }
        return Array(logs)
    }
    
    /// push logs
    /// - Parameter newLogs: push logs
    func pushLogs(_ newLogs: [T]) {
        defer { lock.unlock() }
        lock.lock()
        
        store.append(contentsOf: newLogs)
    }
    
    /// buffer is empty or not
    var isEmpty: Bool {
        return store.isEmpty
    }
}

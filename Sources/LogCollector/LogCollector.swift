//
//  LogCollector.swift
//
//
//  Created by Yugo TERADA on 2022/09/17.
//

import Foundation

/// Log Collector main class
public class LogCollector<T: LogData & Equatable> {
    private var buffer: Buffer<T>!
    private var supervisor: Supervisor<T>!

    /// Initialize and prepre wirker task
    /// - Parameter workerTask: worker task block
    public init(
        workerInterval: Double = 60 * 5,
        workerTask: @escaping (_ logs: [T]) throws -> Void
    ) {
        buffer = Buffer<T>()
        supervisor = Supervisor(
            buffer: buffer,
            workerInterval: workerInterval,
            workerTask: workerTask
        )
    }
    
    /// Store and send log toserver asynchronously
    /// - Parameter log: Log data class
    public func storeLog(log: T) {
        buffer.pushLogs([log])
        supervisor.startWorker()
    }
}

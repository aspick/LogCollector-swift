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
    /// - Parameter bufferBatchSize: max count of payloads to pass each worker task
    /// - Parameter workerInterval: worker invoke interval secounds
    /// - Parameter workerTask: worker task block
    public init(
        bufferBatchSize: Int = 5,
        workerInterval: Double = 60 * 5,
        workerTask: @escaping (_ logs: [T]) throws -> Void
    ) {
        buffer = Buffer<T>(batchSize: bufferBatchSize)
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

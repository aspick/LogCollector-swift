//
//  Supervisor.swift
//  
//
//  Created by Yugo TERADA on 2022/09/17.
//
//

import Foundation

/// Supervisor of worker task class
class Supervisor<T: LogData & Equatable> {
    var timer: Timer? = nil
    var buffer: Buffer<T>!
    var workerInterval: Double!
    var workerTask: (_ logs: [T]) throws -> Void
    
    
    /// Initizlize supervisor class
    /// - Parameters:
    ///   - buffer: buffer instance
    ///   - workerInterval: worker invoke interval secounds
    ///   - workerTask: worker task function
    init(
        buffer: Buffer<T>,
        workerInterval: Double = 60 * 5,
        workerTask: @escaping (_ logs: [T]) throws -> Void
    ) {
        self.buffer = buffer
        self.workerInterval = workerInterval
        self.workerTask = workerTask
    }
    
    
    /// Start timer to invoke worker periodically
    func startWorker() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: workerInterval, repeats: true, block: {_ in
                self.invokeWorker()
                self.stopWorkerIfNeeded()
            })
        }
    }
    
    
    /// Stop timer and inoke worker task finally
    func stopWorker() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
        invokeWorker()
    }
    
    
    /// Invoke worker task
    /// Pop log data from buffer and pass them to worker task
    /// If worker task failed, re-push poped log data to restore initial state
    func invokeWorker() {
        let processingLogs = buffer.popLogs()
        if processingLogs.isEmpty {
            return
        }
        
        do {
            try workerTask(processingLogs)
        } catch {
            buffer.pushLogs(processingLogs)
        }
    }
    
    /// Stop timer if buffer is empty
    func stopWorkerIfNeeded() {
        if buffer.isEmpty {
            stopWorker()
        }
    }
}

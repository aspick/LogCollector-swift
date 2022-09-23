//
//  LogData.swift
//  
//
//  Created by Yugo TERADA on 2022/09/17.
//

import Foundation

/// Log data class protocol
public protocol LogData: Equatable {
    func payload() -> Dictionary<String, Any>
    func orderKey() -> Double
}

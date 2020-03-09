//  LogDelegate.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit

/// Logger output protocol for listening to new log messages to arrive
public protocol LogDelegate {
    
    /// Triggered whenever a new log entry has been added.
    /// Use for to display the output of the log elsewhere or the act upon it in any other way than the default one.
    /// - parameter level: level of severity
    /// - parameter level: log message
    func logUpdate( message: LogMessage)
   
}


//
//  Emvco3dsFrameworkManager.swift
//  emvco3ds-ios-framework

import UIKit

public class Emvco3dsFrameworkManager: NSObject , LogDelegate {

    @objc public var logResults : [LogMessage] = [LogMessage]()
    @objc public let listenToLogLevel : String = Log.screenLevel
    
    // MARK: LogDelegate
    
    @objc public func logUpdate(message: LogMessage){
        if (message.level.contains(listenToLogLevel)){
            logResults.append(message)
        }
    }
}


//  Log.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit

/// Logger class for adding class and time information to the standard console output.
/// In addition it can have output elsewhere through the delegate property.
public class Log: NSObject {

    public static let debugLevel = "d"
    public static let screenLevel = "s"
    public static let screenErrorLevel = "se"
    public static let warningLevel = "w"
    public static let errorLevel = "e"
    public static let infoLevel = "i"
    
    public static var delegate : LogDelegate?
    
    /// Prints a line to the console output and notifies the log delegate.
    /// Use for debugging purposes specifically. There will be output only when debugging.
    /// - parameter object: calling instance, resulting in a class name to display in the output
    /// - returns: void
    public static func d(object: NSObject, message:String){
        #if DEBUG
            print ("\(getTimeStamp()) \(getClassNameForObject(object: object)) \(message)")
            self.informDelegate(level: debugLevel, message: message)
        #endif
    }
    
    /// Prints a line to the console output and notifies the log delegate.
    /// Use for screen output purposes specifically.
    /// - parameter object: calling instance, resulting in a class name to display in the output
    /// - returns: void
    public static func s(object: NSObject, message:String){
        print ("\(getTimeStamp()) \(getClassNameForObject(object: object)) \(message)")
        self.informDelegate(level: screenLevel, message: message)
    }
    
    /// Prints a line to the console output and notifies the log delegate.
    /// Use for screen error output purposes specifically.
    /// - parameter object: calling instance, resulting in a class name to display in the output
    /// - returns: void
    public static func se(object: NSObject, message:String){
        print ("\(getTimeStamp()) \(getClassNameForObject(object: object)) \(message)")
        self.informDelegate(level: screenErrorLevel, message: message)
    }
    
    /// Prints a line to the console output and notifies the log delegate.
    /// Use for information messages only.
    /// - parameter object: calling instance, resulting in a class name to display in the output
    /// - returns: void
    public static func i(object: NSObject, message:String){
        print ("\(getTimeStamp()) \(getClassNameForObject(object: object)) \(message)")
        self.informDelegate(level: infoLevel, message: message)
    }
    
    /// Prints a line to the console output and notifies the log delegate.
    /// Use for warning messages only.
    /// - parameter object: calling instance, resulting in a class name to display in the output
    /// - returns: void
    public static func w(object: NSObject, message:String){
        print ("\(getTimeStamp()) \(getClassNameForObject(object: object)) \(message)")
        self.informDelegate(level: warningLevel, message: message)
    }
    
    /// Prints a line to the console output and notifies the log delegate.
    /// Use for error messages only.
    /// - parameter object: calling instance, resulting in a class name to display in the output
    /// - returns: void
    public static func e(object: NSObject, message:String){
        print ("\(getTimeStamp()) \(getClassNameForObject(object: object)) \(message)")
        self.informDelegate(level: errorLevel, message: message)
    }
    
    private static func getTimeStamp() -> String{
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        return formatter.string(from: currentDateTime)
    }
    
    private static func getClassNameForObject(object:NSObject)->String{
        let name = NSStringFromClass(type(of: object))+"."
        let elements = name.split(separator: ".")
        let result = String(describing: elements[elements.count-1]) as String
        return result
    }
    
    private static func informDelegate(level:String, message:String){
        let logMessage = LogMessage()
        logMessage.level = level
        logMessage.message = message
        delegate?.logUpdate(message: logMessage)
    }
}

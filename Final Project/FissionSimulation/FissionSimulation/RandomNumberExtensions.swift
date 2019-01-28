//
//  RandomNumberExtensions.swift
//  Monte Carlo Integration
//
//  Created by Jeff Terry on 2/1/17.
//  Copyright © 2017 Jeff Terry. All rights reserved.
//

import Cocoa

/*
 Arc Random for UInt32, Double, and Float
 Fixed for Swift 3
 Based upon Swift 2 code by DaRkDOG
 
 Useage:
 let randomNumDouble = Double.getRandomNumber(lower: -7.00, upper: 94.30)
 let randomNumInt = Int.getRandomNumber(lower: 32, upper: 37)
 let randomNumFloat = Float.getRandomNumber(lower: 4.32, upper: 732.3)
 */
 
public func arc4random <T: ExpressibleByIntegerLiteral> (type: T.Type) -> T {
    var randomNumber: T = 0
    arc4random_buf(&randomNumber, MemoryLayout<T>.size)
    return randomNumber
}


public extension Int {
    /// Get Random Integer
    ///
    /// - Parameters:
    ///   - lower: lower bound
    ///   - upper: upper bound
    /// - Returns: random UInt32 returned
    
    public static func getRandomNumber(lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32((upper - lower + 1))))
    }
    
}


public extension Double {
    /// Get Random Double
    ///
    /// - Parameters:
    ///   - lower: lower bound
    ///   - upper: upper bound
    /// - Returns: random Double returned
    
    public static func getRandomNumber(lower: Double, upper: Double) -> Double {
        let randomNumber = Double(arc4random(type: UInt64.self)) / Double(UInt64.max)
        return (randomNumber * (upper - lower)) + lower
    }
}


public extension Float {
    /// Get Random Float
    ///
    /// - Parameters:
    ///   - lower: lower bound
    ///   - upper: upper bound
    /// - Returns: random Float returned
    
    public static func getRandomNumber(lower: Float, upper: Float) -> Float {
        let randomNumber = Float(arc4random(type: UInt32.self)) / Float(UInt32.max)
        return (randomNumber * (upper - lower)) + lower
    }
}


class RandomNumberExtensions: NSObject {

}

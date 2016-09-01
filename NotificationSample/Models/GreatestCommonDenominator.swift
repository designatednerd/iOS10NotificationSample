//
//  GreatestCommonDenominator.swift
//  NotificationSample
//
//  Created by Ellen Shapiro (Work) on 9/1/16.
//  Copyright © 2016 Designated Nerd Software. All rights reserved.
//

import Foundation

struct GreatestCommonDenominator {

    static func of(_ a: Int?, _ b: Int?) -> Int {
        guard let first = a else {
            //If b is also nil, return 0
            return b ?? 0
        }
        
        guard let second = b else {
            return first
        }
        
        //Compare things in a semi-sensible fashion
        var larger: Int
        var smaller: Int
        if first > second {
            larger = first
            smaller = second
        } else {
            larger = second
            smaller = first
        }
        
        var remainder: Int = Int.max
        while remainder > 0 {
            remainder = larger % smaller
            
            if remainder == 0 {
                return smaller
            } else {
                larger = smaller
                smaller = remainder
            }
        }
        
        //We don't have any kind of common divisor. 
        return 1
    }
    
    static func `in`(array:[Int]) -> Int {
        if array.isEmpty {
            //Nothing to divide.
            return 1
        }
        
        let greatestCommonDenominator = array.reduce(array[0]) {
            item, currentGCD in
            return GreatestCommonDenominator.of(item, currentGCD)
        }

        return greatestCommonDenominator
    }
}

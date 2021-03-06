//
//  DecimalExtension.swift
//  CalculatorApp(202204)
//
//  Created by CheChenLiu on 2022/4/13.
//

import Foundation

extension Decimal {
    
    func toDoubleValue() -> Double {
        let double = NSDecimalNumber(decimal: self).doubleValue
        return double
    }
    
    var stringValue:String {
        let string = NSDecimalNumber(decimal: self).stringValue
        return string
    }
    
    var isDecimal:Bool {
        self.stringValue.contains(".")
    }
    
}


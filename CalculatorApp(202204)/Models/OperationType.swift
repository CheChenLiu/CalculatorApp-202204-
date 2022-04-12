//
//  OperationType.swift
//  CalculatorApp(202204)
//
//  Created by CheChenLiu on 2022/4/12.
//

import Foundation

enum OperationType {
    case add
    case sub
    case multi
    case div
    case none
    
    func title() -> String {
        
        switch self {
        case .add:
            return "➕"
        case .sub:
            return "➖"
        case .multi:
            return "✖️"
        case .div:
            return "➗"
        case .none:
            return "There is none operation now."
        }
    }
    
    func tag() -> Int {
        
        switch self {
        case .add:
            return 1
        case .sub:
            return 2
        case .multi:
            return 3
        case .div:
            return 4
        case .none:
            return 999
        }
    }
}



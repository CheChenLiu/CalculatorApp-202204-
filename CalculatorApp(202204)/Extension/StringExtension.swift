//
//  StringExtension.swift
//  CalculatorApp(202204)
//
//  Created by CheChenLiu on 2022/4/13.
//

import Foundation

extension String {
    func toDecimalValue() -> Decimal? {
        let decimal = Decimal(string: self)
        return decimal
    }
}


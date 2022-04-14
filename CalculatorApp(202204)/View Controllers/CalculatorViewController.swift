//
//  CalculatorViewController.swift
//  CalculatorApp(202204)
//
//  Created by CheChenLiu on 2022/4/11.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    private var tempNumber: String? = "0"
    private var previousNumber: Decimal = 0
    private var result: Decimal = 0
    
    private var isOperating: Bool = false
    private var isNegative: Bool = false
    private var isDecimal: Bool = false
    
    private var operationType: OperationType = .none
    
    private var maxNumberCount: Int = 10
    
    @IBOutlet weak var numberLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        numberLabel.text = Number.zero.title()
    }
    
    @IBAction func pressNumberButton(_ sender: UIButton) {
        
        let numberTag: Int = sender.tag
        var inputNumber: String = ""
        
        inputNumber = "\(numberTag)"
        print("inputNumber = \(inputNumber)")
        
        let tempNumberCount = tempNumber?.count ?? 0
        
        if tempNumberCount >= maxNumberCount && !isNegative {
            print("tempNumberCount = maxNumberCount so addSpace Now")
        } else if tempNumberCount - 1 >= maxNumberCount && isNegative {
            print("tempNumberCount = maxNumberCount so addSpace Now")
        } else {
            updateLabelFrame(inputNumber: inputNumber)
        }
    }
    
    private func updateLabelFrame(inputNumber: String) {
        
        let inputNumberIsZero = inputNumber == Number.zero.title()
        
        // 如果目前數字是 0，再次點擊 0 時不會顯示多個 0
        if numberLabel.text == Number.zero.title() && inputNumberIsZero {
            return
        }
        
        addInputString(inputNumber: inputNumber)
    }
    
    private func addInputString(inputNumber: String) {
        
        var result: String = ""
        
        if isNegative {
            result = "-"
        } else {
            result = ""
        }
       
        if let tempNumber = tempNumber {
            print("tempNumber = \(tempNumber)")
            if tempNumber == "0" && !isNegative && inputNumber != "" {
                self.tempNumber = inputNumber
            } else {
                self.tempNumber = tempNumber + inputNumber
            }
            print("tempNumber = \(tempNumber)")
            print("inputNumber = \(inputNumber)")
            
            result = result + self.tempNumber!
            print("result = \(result)")
        } else {
            
            tempNumber = inputNumber
            result += inputNumber
        }
        
        numberLabel.text = format(string: result)
    }
    
    @IBAction func pressDotButton(_ sender: UIButton) {
        
        if isDecimal {
            return
        }
        
        isDecimal = true
        
        if isOperating && tempNumber == nil {
            
            numberLabel.text = "0."
            tempNumber = "0."
            return
        }
        
        if let tempNumber = tempNumber {
            
            self.tempNumber = tempNumber + "."
            numberLabel.text = self.tempNumber
            
        } else {
            
            numberLabel.text = "0."
            
        }
    }
    
    @IBAction func pressFactorialButton(_ sender: UIButton) {
        
        if factorial(factorialNumber: self.tempNumber) == 0 {
            
            numberLabel.text = "錯誤"
            
        } else {
            
            let intFactorialNumber = String(factorial(factorialNumber: self.tempNumber))
            
            numberLabel.text = format(string: intFactorialNumber)
        }
    }
    
    //階乘:只接受正整數 0! = 1, 讓階乘數為零時回傳1, 大於零都繼續乘上自己的數字 - 1
    private func factorial(factorialNumber: String?) -> Int {
        
        let intFactorialNumber = Int(factorialNumber ?? "錯誤")
        
        if isDecimal || isNegative {
            return 0
        }
        
        if let intFactorialNumber = intFactorialNumber {
            
            if intFactorialNumber == 0 {
                
                return 1

            } else {
                
                let numberString = "\(intFactorialNumber - 1)"
                
                if intFactorialNumber > 20 {
    
                    return 0
                    
                } else {
                    
                    let result = intFactorialNumber * factorial(factorialNumber: numberString)
                    return result
                    
                }
            }
            
        } else {
            
            return 0
        }
    }
    
    private func format(string: String) -> String {

        var needAppendLastZero:String = ""
        var whileString = string
        
        while whileString.last == "0" && whileString.contains(".") {
            
            needAppendLastZero += "0"
            whileString.removeLast()
            print("whileString = \(whileString)")
        }

        if let decimal = string.toDecimalValue() {
            
            var result = format(decimal: decimal)
            
            print("decimal = \(decimal)")
            
            if string == "-0" {
                
                numberLabel.text = "-0"
                
                return string
                
            } else {
                
                if !needAppendLastZero.isEmpty {
                    
                    if !decimal.isDecimal {
                        result += "."
                    }
    
                    result += needAppendLastZero
                    
                }
                
                return result
            }
            
        } else {
            
            return "錯誤"
            
        }
    }
    
    private func format(decimal: Decimal) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 9
        let formatterString = formatter.string(from: decimal as NSDecimalNumber) ?? "0"
        return formatterString
    }
    
    private func getCurrentDecimal() -> Decimal? {
        if let tempNumber = tempNumber {
            var result = isNegative ? "-" : ""
            result += tempNumber
            return result.toDecimalValue()
        } else {
            return nil
        }
    }
    
    @IBAction func pressNegativeButton(_ sender: UIButton) {
        isNegative = !isNegative
        print("isNegative = \(isNegative)")
        updateLabelFrame(inputNumber: "")
    }
    
    @IBAction func pressOperationButton(_ sender: UIButton) {
        
        if let decimal = getCurrentDecimal() {
            previousNumber = decimal
        } else {
            previousNumber = 0
        }
        
        print("previousNumber = \(previousNumber)")
        
        isOperating = true
        isNegative = false
        isDecimal = false
        
        tempNumber = nil

        chooseOperationType(tag: sender.tag)
    }
    
    private func chooseOperationType(tag: Int) {
        
        switch tag {
        case OperationType.add.tag():
            operationType = .add
            print("operation = \(OperationType.add.title())")
        case OperationType.sub.tag():
            operationType = .sub
            print("operation = \(OperationType.sub.title())")
        case OperationType.multi.tag():
            operationType = .multi
            print("operation = \(OperationType.multi.title())")
        case OperationType.div.tag():
            operationType = .div
            print("operation = \(OperationType.div.title())")
        case OperationType.none.tag():
            operationType = .none
            print("operation = \(OperationType.none.title())")
        default:
            print("error: can't find tag in OperationType")
        }
    }
    
    @IBAction func pressEqualButton(_ sender: UIButton) {
        
        calculateResult()
        updateResult()
    }
    
    private func calculateResult() {

        let currentNumber = tempNumber?.toDecimalValue() ?? 0

        switch operationType {
        case .add:
            result = previousNumber + currentNumber
        case .sub:
            result = previousNumber - currentNumber
        case .multi:
            result = previousNumber * currentNumber
        case .div:
            result = previousNumber / currentNumber
        case .none:
            result = currentNumber
        }
        
        print("currentNumber = \(currentNumber), previousNumber = \(previousNumber), operationType = \(operationType.title())")
        
        numberLabel.text? = "\(result)"
    }
    
    private func updateResult() {
        
        if result.isNaN {
            
            numberLabel.text = "錯誤"
            
        } else if (result >= pow(10, maxNumberCount)) || result <= (pow(-10, maxNumberCount) * -1) {
            
            print("maxNumber = \(pow(10, maxNumberCount)), minNumber = \((pow(-10, maxNumberCount) * -1))")
            print("result = \(result)")
            powerFormat(result: result)
            
        } else {
            
            numberLabel.text = format(decimal: result)
            
        }
    }
    //超過最大數時，result轉換為 x 乘 e 的 y次方 顯示
    private func powerFormat(result: Decimal) {
        
        var power: Double = 0
        var powerTotal: Decimal = 1
        let ten: Decimal = 10
        
        if result > 0 {
            //floor() 無條件捨去
            power = floor(log10(result.toDoubleValue()))
            print("power = \(power)")
        } else {
            power = floor(log10(result.toDoubleValue() * -1))
            print("power = \(power)")
        }
        
        for _ in 1...Int(power) {
            powerTotal *= ten
        }
        print("powerTotal = \(powerTotal)")
        
        let preResultNumber = result / powerTotal
        print("preResultNumber = \(preResultNumber)")
        
        numberLabel.text = format(decimal: preResultNumber) + "e" + format(decimal: Decimal(power))
    }
    
    @IBAction func pressACButton(_ sender: UIButton) {
        
        reset()
    }
    
    private func reset() {
        
        numberLabel.text = "0"
        tempNumber = "0"
        previousNumber = 0
        result = 0
        
        isOperating = false
        isNegative = false
        isDecimal = false
        
        operationType = .none
        print("Clear All")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

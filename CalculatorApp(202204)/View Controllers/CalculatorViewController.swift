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
        
        if tempNumberCount >= maxNumberCount {
            print("tempNumberCount = maxNumberCount so addSpace Now")
        } else {
            updateLabelFrame(inputNumber: inputNumber)
        }
    }
    
    private func updateLabelFrame(inputNumber: String) {
        
        let inputNumberIsZero = (inputNumber == Number.zero.title())
        
        // 如果目前數字是 0，再次點擊 0 時不會顯示多個 0
        if numberLabel.text == Number.zero.title() && inputNumberIsZero {
            return
        }
        
        addInputString(inputNumber: inputNumber)
    }
    
    private func addInputString(inputNumber: String) {
        
        var result: String = ""
       
        if let tempNumber = tempNumber {
            print("tempNumber = \(tempNumber)")
            
            if tempNumber == "0" {
                
                self.tempNumber = inputNumber
                
            } else {
                
                self.tempNumber = tempNumber + inputNumber
                
            }
            
            print("self.tempNumber = \(self.tempNumber ?? "0")")
            result = result + self.tempNumber!
            
        } else {
            
            tempNumber = inputNumber
            result += inputNumber
            
        }
        
        numberLabel.text = "\(result)"
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
            
            numberLabel.text = "\(factorial(factorialNumber: self.tempNumber))"
        }
    }
    
    //階乘:只接受正整數 0! = 1, 讓階乘數為零時回傳1, 大於零都繼續乘上自己的數字 - 1
    private func factorial(factorialNumber: String?) -> Int {
        
        let intFactorialNumber = Int(factorialNumber ?? "錯誤")
        
        guard !isDecimal else {
            return 0
        }
        
        if let intFactorialNumber = intFactorialNumber {
            
            if intFactorialNumber == 0 {
                
                return 1
                
            } else if intFactorialNumber < 0 {
                
                return 0
                
            } else {
                
                let numberString = "\(intFactorialNumber - 1)"
                
                let result = intFactorialNumber * factorial(factorialNumber: numberString)
                
                return result
            }
            
        } else {
            
            return 0
        }
    }
    
    @IBAction func pressOperationButton(_ sender: UIButton) {
        
        isOperating = true
        isDecimal = false
        
        tempNumber = nil
        previousNumber = numberLabel.text?.toDecimalValue() ?? 0
        
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
        
        print("currentNumber = \(currentNumber), previousNumber = \(previousNumber)")
        print("result = \(result)")
        
        numberLabel.text? = "\(result)"
    }
    
    private func updateResult() {
        
        if result.isNaN {
            
            numberLabel.text = "錯誤"
            
        } else if result >= pow(10, maxNumberCount) {
            
            print("result = \(result)")
            powerFormat(result: result)
        }
        
    }
    //超過最大數時，result轉換為 x 乘 e 的 y次方 顯示
    private func powerFormat(result: Decimal) {
        
        var power: Double = 0
        var powerTotal: Decimal = 1
        let ten: Decimal = 10
        
        if result > 0 {
            
            power = floor(log10(result.toDoubleValue()))
            print("power = \(power)")
            
        }
        
        for _ in 1...Int(power) {
            powerTotal *= ten
        }
        
        let preResultNumber = result / powerTotal
        print("line 258")
        print("preResultNumber = \(preResultNumber)")
        
        numberLabel.text = "\(preResultNumber)" + "e" + "\(Int(power))"
        print("\(preResultNumber)" + "e" + "\(Int(power))")
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

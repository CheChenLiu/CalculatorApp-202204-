//
//  LoginViewController.swift
//  CalculatorApp(202204)
//
//  Created by CheChenLiu on 2022/4/11.
//

import UIKit

class LoginViewController: UIViewController {
    
    private var correctUserName = "rayliu"
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
        userNameTextField.placeholder = "請輸入使用者名稱"
        loginButton.layer.cornerRadius = 10
        loginButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    @IBAction func login(_ sender: Any) {
        
        let userNameCapitalization = userNameTextField.text?.lowercased() == correctUserName
        
        if userNameCapitalization {
            print("Login Success, userName = \(userNameTextField.text ?? "")")
            goToCalculatorViewController()
        } else if userNameTextField.text?.isEmpty == true {
            showAlert(title: "使用者名稱不得為空", message: "請重新輸入")
        } else if userNameTextField.text != correctUserName {
            showAlert(title: "使用者名稱不對", message: "請重新輸入")
        }
    }
    
    private func goToCalculatorViewController() {
        
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "\(CalculatorViewController.self)") as? CalculatorViewController {
            
            self.navigationController?.pushViewController(viewController, animated: true)
            self.reset()
            
        } else {
            print("something Error")
        }
    }
    
    private func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
            self.reset()
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func reset() {
        
        userNameTextField.text = ""
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

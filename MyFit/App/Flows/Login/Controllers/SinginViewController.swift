//
//  SinginViewController.swift
//  MyFit
//
//  Created by Андрей Закусов on 10.09.2020.
//  Copyright © 2020 Андрей Закусов. All rights reserved.
//

import UIKit

class SinginViewController: UIViewController {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var onMap: (() -> Void)?
    var onLogin: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func singinButtonPress(_ sender: Any) {
        guard let userName = loginTextField.text, let userPassword = passwordTextField.text,
            userName != "", userPassword != ""
            else {
                let alert = UIAlertController(title: "Error", message: "You must fill in your username and password", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                return
        }
        let isCorrectUser = DBRealm.shared.addUser(login: userName, password: userPassword)
        if isCorrectUser {
            onMap?()
        }else{
            let alert = UIAlertController(title: "Error", message: "Registration error.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
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

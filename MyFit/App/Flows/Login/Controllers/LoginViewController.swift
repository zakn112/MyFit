//
//  LoginViewController.swift
//  MyFit
//
//  Created by Андрей Закусов on 09.09.2020.
//  Copyright © 2020 Андрей Закусов. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var onMap: (() -> Void)?
    var onSingin: (() -> Void)?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    
   // MARK: - button's events
    @IBAction func loginButtonPress(_ sender: Any) {
        guard let userName = loginTextField.text, let userPassword = passwordTextField.text,
            userName != "", userPassword != ""
            else {
                let alert = UIAlertController(title: "Error", message: "You must fill in your username and password", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                return
        }
        let isCorrectUser = DBRealm.shared.checkUser(login: userName, password: userPassword)
        if isCorrectUser {
            onMap?()
        }else{
            let alert = UIAlertController(title: "Error", message: "Invalid username or password.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func singinButtonPress(_ sender: Any) {
        onSingin?()
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

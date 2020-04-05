//
//  AuthViewController.swift
//  Cha Chat
//
//  Created by 송용규 on 13/02/2020.
//  Copyright © 2020 송용규. All rights reserved.
//

import UIKit
import Firebase

class AuthViewController: UIViewController {
    @IBOutlet weak var emailTExtField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var loggingIn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.endEditing(true)
        checkCurrentUser()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    
    @IBAction func loginClicked(_ sender: Any) {
        login()
    }
    
    
    @IBAction func forgotPassClicked(_ sender: Any) {
        resetPassword()
    }
    
    
    @IBAction func registerClicked(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController"){
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    func login () {
        
        if(!checkInput()){ return }
        let email = emailTExtField.text!
        let password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password){
            (user,error) in
            if let err = error {
                Utilites().showAlert(title: "ERROR", message: err.localizedDescription, vc: self)
                print("error : " + err.localizedDescription)
            }
            //self.dismiss(animated: true, completion: nil)
            print("Success")
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") {
                self.present(vc, animated: true,completion: nil)
            }
        }
    }
    
    func resetPassword () {
        if (emailTExtField.text!.isEmpty) {
            Utilites().showAlert(title: "ERROR", message: "Email is empty", vc: self)
            return
        }
        let email = self.emailTExtField.text!
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let err = error {
                Utilites().showAlert(title: "ERROR", message: err.localizedDescription, vc: self)
            }
            Utilites().showAlert(title: "Success", message: "Plaese Check Your mail inox for a password reset link", vc: self)
        }
    }
    
    func checkInput() -> Bool{
        if (emailTExtField.text?.count)! < 5 {
            emailTExtField.backgroundColor = UIColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 0.2)
            Utilites().showAlert(title: "ERROR", message: "Email incorrectly formatted", vc: self)
            return false
        }else{
            emailTExtField.backgroundColor = UIColor.white
        }
        if (passwordTextField.text?.count)! < 5{
            emailTExtField.backgroundColor = UIColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 0.2)
            Utilites().showAlert(title: "ERROR", message: "Password too short", vc: self)
            return false
        }else{
            passwordTextField.backgroundColor = UIColor.white
        }
        return true
    }
    
    func checkCurrentUser(){
        if(Auth.auth().currentUser == nil){
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController"){
                //self.navigationController?.pushViewController(vc, animated: true)
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}

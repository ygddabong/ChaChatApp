//
//  SignupViewController.swift
//  Cha Chat
//
//  Created by 송용규 on 18/02/2020.
//  Copyright © 2020 송용규. All rights reserved.
//

import UIKit
import Firebase


class SignupViewController: UIViewController{
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTExtField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    let picker = UIImagePickerController()
    
    @IBAction func registerClicked(_ sender: Any) {
        register()
    }
    @IBAction func addAction(_ sender: Any) {
        let alert =  UIAlertController(title: "Title", message: "Message", preferredStyle: .actionSheet)
        
        let library =  UIAlertAction(title: "Photo Album", style: .default) { (action) in self.openLibrary()
        }
        
        let camera =  UIAlertAction(title: "Camara", style: .default) { (action) in
            self.openCamera()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        imageView.layer.cornerRadius = 40
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.green.cgColor
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func register() {
        if(!checkInput()){ return }
        
        let alert = UIAlertController(title: "Register", message: "Please confirm Password", preferredStyle: .alert)
        
        alert.addTextField{(textField) in
            textField.isSecureTextEntry = true
            textField.placeholder = "Password"
            
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action) in
            let passWordConf = alert.textFields![0]
            if (passWordConf.text!.isEqual(self.passwordTextField.text)){
                guard let email = self.emailTExtField.text else { return }
                guard let password = self.passwordTextField.text else { return }
                guard let name = self.nameTextField.text else {return}
                
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if let err = error {
                        print("err : \(err.localizedDescription)")
                        return
                    }
                    
                    guard let image = self.imageView.image?.jpegData(compressionQuality: 0.1 ) else {
                        Utilites().showAlert(title: "ERROR", message: "IMAGE NOT FIND", vc: self)
                        return
                    }
                    let userUid = user?.user.uid
                    let ramdomID = UUID.init().uuidString
                    let uploadRef = Storage.storage().reference(withPath: "userImages/\(ramdomID).jpg")
                    let uploadMetadata = StorageMetadata.init()
                    
                    uploadMetadata.contentType = "images/jpeg"
                    
                    uploadRef.putData(image, metadata: uploadMetadata){(downloadMetadata, error) in
                        if let error = error {
                            print("error : \(error.localizedDescription)")
                            return
                        }
                        uploadRef.downloadURL { (url, error) in
                            if let error = error { return }
                            if let url = url {
                                print(url)
                            }
                            Database.database().reference().child("users").child(userUid!).setValue([
                                "email": self.emailTExtField.text!,
                                "password": self.passwordTextField.text!,
                                "name" : self.nameTextField.text!,
                                "profileImageUrl":url?.absoluteString,
                                "userUid": userUid
                            ])
                        }
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
            else {
                Utilites().showAlert(title: "ERROR", message: "Passwords don't match", vc: self)
            }
        }))
        self.present(alert, animated: true, completion: nil)
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
    
    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    func openCamera(){
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
    }
    
    
}

extension SignupViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}



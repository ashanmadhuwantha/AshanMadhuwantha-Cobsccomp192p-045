//
//  SignUpViewController.swift
//  AshanMadhuwantha-Cobsccomp192p-045
//
//  Created by Ashan Madhuwantha on 2021-04-28.
//

import UIKit
import Loaf
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var btnSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignUp.layer.cornerRadius = 20
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onLoginPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSignUpPressed(_ sender: UIButton) {
        
        if !InputValidator.isValidName(name: txtName.text ?? "") {
            Loaf("Invalid Name", state: .error, sender: self).show()
            return
        }
        
        if !InputValidator.isValidEmail(email: txtEmail.text ?? "") {
            Loaf("Invalid Email", state: .error, sender: self).show()
            return
        }
        
        if !InputValidator.isValidMobileNo(txtPhone.text ?? "") {
            Loaf("Invalid Email", state: .error, sender: self).show()
            return
        }
        
        if !InputValidator.isValidPassword(pass: txtPassword.text ?? "", minLength: 5, maxLength: 50) {
            Loaf("Invalid Email", state: .error, sender: self).show()
            return
        }
        
        if !(txtPassword.text == txtConfirmPassword.text ){
            Loaf("Passwords Not Match", state: .error, sender: self).show()
            return
        }
        
        let user = User(userName: txtName.text ?? "", userEmail: txtEmail.text ?? "", userPassword: txtPassword.text ?? "", userPhone: txtPhone.text ?? "")
        
        registerUser(user: user)
        
        
    }
    
    func registerUser(user:User) {
        Auth.auth().createUser(withEmail: user.userEmail, password: user.userPassword) { authResult, error in
            
            if let err = error {
                print(err.localizedDescription)
                Loaf("User Signup failed", state: .error, sender: self).show()
                return
            }
            
            self.saveUserInfo(user: user)
        }
        
    }
    
    func saveUserInfo(user: User) {
        
        let userData = [
            "userName" : user.userName,
            "userPassword" : user.userPassword,
            "userEmail" : user.userEmail,
            "userPhone" : user.userPhone
        
        ]
        
        self.ref.child("users").child(user.userEmail.replacingOccurrences(of: "@", with: "_").replacingOccurrences(of: ".", with: "_")).setValue(userData) {
            (error, ref) in
            
            if let err = error {
                print(err.localizedDescription)
                Loaf("User Data Not Saved", state: .error, sender: self).show()
                return
            }
            
            Loaf("User Data Saved", state: .success, sender: self).show {
                type in
                self.dismiss(animated: true, completion: nil)
            }
            
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

//
//  LoginViewController.swift
//  AshanMadhuwantha-Cobsccomp192p-045
//
//  Created by Ashan Madhuwantha on 2021-04-28.
//

import UIKit
import Firebase
import Loaf

class LoginViewController: UIViewController {

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogin.layer.cornerRadius = 20
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onForgotPasswordPressed(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: txtEmail.text ?? "") { error in
         
        }
        
    }
    @IBAction func onSignUpPressed(_ sender: UIButton) {
    }
    
    @IBAction func onLoginPressed(_ sender: UIButton) {
        
        if !InputValidator.isValidEmail(email: txtEmail.text ?? "") {
            Loaf("Invalid Email", state: .error, sender: self).show()
            return
        }
        
        if !InputValidator.isValidPassword(pass: txtPassword.text ?? "", minLength: 5, maxLength: 100) {
            Loaf("Invalid Password", state: .error, sender: self).show()
            return
        }
        
        aunthenticateUser(email: txtEmail.text!, password: txtPassword.text!)
        
    }
    
    func aunthenticateUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            if let err = error {
                Loaf("Username or Password is invalid", state: .error, sender: self).show()
                print(err.localizedDescription)
                
                return
            }
            if let email = authResult?.user.email {
                
                self.getUserDetails(email:email)
            } else {
                Loaf("User email not found", state: .error, sender: self).show()
            }
            
        }
    }
    
    
    func getUserDetails(email: String) {
        
        ref.child("users").child(email.replacingOccurrences(of: "@", with: "_").replacingOccurrences(of: ".", with: "_")).observe(.value, with: {
            (snapshot) in
            
            if snapshot.hasChildren() {
                
                if let data = snapshot.value {
                    if let userData = data as? [String: String] {
                        let user = User(
                            userName: userData["userName"]!,
                            userEmail: userData["userEmail"]!,
                            userPassword: userData["userPassword"]!,
                            userPhone: userData["userPhone"]!
                        )
                        let sessionMGR = SessionManager()
                        sessionMGR.saveUserLogin(user: user)
                        self.performSegue(withIdentifier: "LoginToHome", sender: nil)
                        
                    }
                }
                
            } else {
                Loaf("User not found", state: .error, sender: self).show()
            }
    })
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

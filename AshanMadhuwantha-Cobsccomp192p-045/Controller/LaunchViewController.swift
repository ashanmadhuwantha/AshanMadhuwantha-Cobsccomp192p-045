//
//  LaunchViewController.swift
//  AshanMadhuwantha-Cobsccomp192p-045
//
//  Created by Ashan Madhuwantha on 2021-04-28.
//

import UIKit

class LaunchViewController: UIViewController {
    
    let sessionMGR = SessionManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if sessionMGR.getLoggedState() {
            self.performSegue(withIdentifier: "LaunchToHome", sender: nil)
            
        } else {
            self.performSegue(withIdentifier: "LaunchToLogin", sender: nil)
            
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

//
//  loginVC.swift
//  insta
//
//  Created by pop on 2/11/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Firebase
class loginVC: UIViewController {

    @IBOutlet weak var emailtxtf: UITextField!
    @IBOutlet weak var passtxtf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func loginBTN(_ sender: Any) {
        // LOGIN : -
        guard let email = emailtxtf.text , emailtxtf.text != nil,let pass = passtxtf.text , passtxtf.text != nil
            else{return}
        FIRAuth.auth()?.signIn(withEmail: email, password: pass, completion: { (user, error) in
            if error != nil{
                print(error)
                return
            }else{
                let homevc = self.storyboard?.instantiateViewController(withIdentifier: "navid")
                //activeuser.saveuser(data: true)
                self.present(homevc!, animated: true, completion: nil)
            }
        })
        
    }

}

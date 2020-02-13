//
//  beginVC.swift
//  insta
//
//  Created by pop on 2/11/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit

class beginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loginBTN(_ sender: Any) {
        performSegue(withIdentifier: "gotologin", sender: nil)
    }
    @IBAction func registerBTN(_ sender: Any) {
        performSegue(withIdentifier: "gotoregister", sender: nil)
    }

}

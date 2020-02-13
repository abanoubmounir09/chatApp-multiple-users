//
//  registerVC.swift
//  insta
//
//  Created by pop on 2/11/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class registerVC: UIViewController {

    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var nametxtf: UITextField!
    @IBOutlet weak var emailtxtf: UITextField!
    @IBOutlet weak var passtxtf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let mygesture = UITapGestureRecognizer(target: self, action: #selector(handleimage))
        userimage.isUserInteractionEnabled = true
        userimage.addGestureRecognizer(mygesture)
        
    }
    
    
    
    @IBAction func registerBTN(_ sender: Any) {
        SVProgressHUD.show()
        //storage image
        let imagename = NSUUID().uuidString
        let StorageRef = FIRStorage.storage().reference().child("profile-images").child("\(imagename).jpg")
        if let uploadData = UIImageJPEGRepresentation(userimage.image!, 0.1){
            StorageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error)
                    return
                }
                let profileurl = metadata?.downloadURL()?.absoluteString
                self.register(url: profileurl!)
            })
        }
        /*if let uploadData = UIImagePNGRepresentation(userimage.image!){
         
         }*/
        
    }
    
    func register(url:String){
        let mydatabase = FIRDatabase.database().reference().child("users")
        guard let name = nametxtf.text, nametxtf.text != nil else {return}
        guard let email =  emailtxtf.text, emailtxtf.text != nil else {return}
        guard let pass = passtxtf.text , passtxtf.text != nil else {return}
    
       
        FIRAuth.auth()?.createUser(withEmail: email, password: pass, completion: { (user, error) in
            if error != nil{
                print(error)
                SVProgressHUD.dismiss()
            }else{
                //activeuser.saveuser(data: true)
                 let uid = user?.uid
                print("user id is *** ----- *** \(uid)")
                let values = ["name" : name, "email":email, "password":pass,"profileimage":url,"uid":uid]
                mydatabase.child(uid!).setValue(values){(error,ref) in
                    if error != nil{
                        print(error)
                    }
                    SVProgressHUD.dismiss()
                    print("user added to database")
                    let tabbarID = self.storyboard?.instantiateViewController(withIdentifier: "navid")
                    self.present(tabbarID!, animated: true, completion: nil)
                }
                //print("successfully user registerd")
            }
        })
       
    }
}



extension registerVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    // handle Image:
    @objc func handleimage(){
        let imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        imagepicker.sourceType = .photoLibrary
        imagepicker.allowsEditing = false
        present(imagepicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        userimage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
}

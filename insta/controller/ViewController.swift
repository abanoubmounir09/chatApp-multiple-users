//
//  ViewController.swift
//  insta
//
//  Created by pop on 2/11/20.
//  Copyright © 2020 pop. All rights reserved.
// messagesviwcntroller

import UIKit
import Firebase
class ViewController: UIViewController {
    @IBOutlet weak var mytableview: UITableView!
    var messages = [Message]()
    let cellID = "cellID"
    var image2:UIImage?
    var messageDictionary = [String:Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(handlelogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "list", style: .plain, target: self, action: #selector(handlnewmessage))
        mytableview.delegate = self
        mytableview.dataSource = self
        mytableview.register(UserCell.self, forCellReuseIdentifier: cellID)
        ckeckuserlogin()
       // observemessage()
       
    }
    
    func  observeUserMessages(){
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference().child("user-message").child(uid!)
        ref.observe(.childAdded) { (snapshot) in
            let messageID = snapshot.key
            let ref = FIRDatabase.database().reference().child("message").child(messageID)
            ref.observeSingleEvent(of: .value , with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any]{
                    let message = Message()
                    message.fromid = dictionary["fromid"] as? String
                    message.message = dictionary["message"] as? String
                    message.timestamp = dictionary["timestamp"] as? NSNumber
                    message.toid = dictionary["toid"] as? String
                    
                    var chatPartnerId : String?
                    if  message.fromid == FIRAuth.auth()?.currentUser?.uid {
                        chatPartnerId = message.toid
                    }else{
                        chatPartnerId = message.fromid
                    }
                    if let toid = chatPartnerId{
                        self.messageDictionary[toid] = message
                        self.messages = Array(self.messageDictionary.values)
 
                        /*self.messages.sort(by: { (m1, m2) -> Bool in
                         return m1.timestamp?.intValue > m2.timestamp?.intValue
                         })*/
                        
                    }
                    self.mytableview.reloadData()
                }            })
            
        }
    }
    
    
    @objc func handlnewmessage(){
        let newmessagecontroler = NewMessageController()
        newmessagecontroler.viewcontroler = self
        let navnewmessagecontroler = UINavigationController(rootViewController: newmessagecontroler)
        present(navnewmessagecontroler, animated: true, completion: nil)
    }
    
    func ckeckuserlogin(){
        if FIRAuth.auth()?.currentUser?.uid == nil{
            handlelogout()
        }else{
            let id = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(id!).observeSingleEvent(of: .value, with: { (snapshot) in
                let dict = snapshot.value as? [String:Any]
                let user = User()
                user.name = dict!["name"] as? String
                user.email = dict!["email"] as? String
                user.uid = dict!["uid"] as? String
                user.profileimage = dict!["profileimage"] as? String
                self.setupnavBarwithuser(user: user)
            })
        }
    }
    
    
    func setupnavBarwithuser(user:User){
        messages.removeAll()
        messageDictionary.removeAll()
         observeUserMessages()
        let name = user.name
        let titleview = UIView()
        titleview.frame = CGRect(x: 0, y: 0, width: 50, height: 40)
        titleview.backgroundColor = UIColor.white
        let textlabel = UILabel()
        textlabel.frame = CGRect(x: 8, y: 0, width: 50, height: 40)
        textlabel.text = name
        titleview.addSubview(textlabel)
        self.navigationItem.titleView = titleview
        let tapgest = UITapGestureRecognizer(target: self, action: #selector(ShowchatViewControllerForUser))
       // titleview.addGestureRecognizer(tapgest)
        
    }
    
    @objc func ShowchatViewControllerForUser(user:User){
        let vc = storyboard?.instantiateViewController(withIdentifier: "chatvc") as? ChatLogController
        vc?.SelectedUser = user
       /* let chatlog = ChatLogController()
        navigationController?.pushViewController(chatlog, animated: true)*/
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func handlelogout(){
        do{
             try FIRAuth.auth()?.signOut()
        }catch let error{
         print(error)
        }
       
        let vc = storyboard?.instantiateViewController(withIdentifier: "startvc")
        present(vc!, animated: true, completion: nil)
    }

 


}



extension ViewController:UITableViewDelegate,UITableViewDataSource{
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mytableview.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? UserCell
        let singlemessageOB = messages[indexPath.row]
        cell?.singlemessage = singlemessageOB
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = messages[indexPath.row]
        guard let chatPartnerID = user.chatPArtID() else{return }
        let ref = FIRDatabase.database().reference().child("users").child(chatPartnerID)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            let dict = snapshot.value as? [String:Any]
            let user = User()
            user.name = dict!["name"] as? String
            user.email = dict!["email"] as? String
            user.uid = dict!["uid"] as? String
            user.profileimage = dict!["profileimage"] as? String
            self.ShowchatViewControllerForUser(user: user)
        }
    }
}









//
//  ChatLogController.swift
//  insta
//
//  Created by pop on 2/11/20.
//  Copyright © 2020 pop. All rights reserved.
// chat page

import UIKit
import Firebase

class ChatLogController: UIViewController {
    
    @IBOutlet weak var mytableview: UITableView!
    @IBOutlet weak var viewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var messageTXTF: UITextField!
    var SelectedUser:User?
    var mesagesdict = [Message]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = SelectedUser?.name
        messageTXTF.delegate = self
        mytableview.delegate = self
        mytableview.dataSource = self
        observeMessages()
    }
    
    func observeMessages(){
        guard let uid = FIRAuth.auth()?.currentUser!.uid else{return}
        let ref = FIRDatabase.database().reference().child("user-message").child(uid)
        ref.observe(.childAdded) { (snapshot) in
            let messageID = snapshot.key
            let messageref = FIRDatabase.database().reference().child("message").child(messageID)
            messageref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any]{
                    let message = Message()
                    message.toid = dictionary["toid"] as? String
                    message.fromid = dictionary["fromid"] as? String
                    message.message = dictionary["message"] as? String
                    message.timestamp = dictionary["timestamp"] as? NSNumber
                    if  self.SelectedUser?.uid == message.chatPArtID(){
                         self.mesagesdict.append(message)
                        self.mytableview.reloadData()
                    }
                }
            })
        }
    }
    @IBAction func sendmessageBTN(_ sender: Any) {
        
        messageTXTF.isEnabled = false
        let mydatabase = FIRDatabase.database().reference().child("message")
        let childref = mydatabase.childByAutoId()
        let toid = SelectedUser?.uid
        let fromid = FIRAuth.auth()?.currentUser!.uid
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let values = ["fromid":fromid,"toid":toid,"message":messageTXTF.text,"timestamp":timestamp] as [String : Any]
        //childref.updateChildValues(values)
        childref.setValue(values) { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            let usermessageRef = FIRDatabase.database().reference().child("user-message").child(fromid!)
            let messageid = childref.key
            usermessageRef.updateChildValues([messageid: 1])
            let recipienusermessage = FIRDatabase.database().reference().child("user-message").child(toid!)
            recipienusermessage.updateChildValues([messageid: 1])
        }
        print("123 message send ")
        messageTXTF.isEnabled = true
        messageTXTF.text = ""
    }

  

}// end class


     extension ChatLogController:UITextFieldDelegate{
     
     func textFieldDidBeginEditing(_ textField: UITextField) {
     UIView.animate(withDuration: 0.5) {
     self.viewHeightConst.constant = 260 //250 keyboard + its height
     self.view.layoutIfNeeded()
     }
     }
     
     func textFieldDidEndEditing(_ textField: UITextField) {
     UIView.animate(withDuration: 0.5) {
     self.viewHeightConst.constant = 0 //250 keyboard + its height
     self.view.layoutIfNeeded()
     }
     }
     
     }


 extension ChatLogController:UITableViewDelegate,UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return mesagesdict.count
                }
 
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = mytableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? chatCell
            let singleMesage = mesagesdict[indexPath.row]
            if singleMesage.fromid == FIRAuth.auth()?.currentUser!.uid{
                cell?.backGroundView.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
               // cell?.leftconstraint.constant = 50
               // cell?.rightconstrain.constant = 0
            }else{
                cell?.backGroundView.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                //cell?.rightconstrain.constant = 60
               //  cell?.leftconstraint.constant = 0
            }
               cell?.messageLB.text = singleMesage.message
            return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
 
 }
 
 
 
 
 
 
 
 
 

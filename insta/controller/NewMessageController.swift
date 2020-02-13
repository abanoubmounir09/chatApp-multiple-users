//
//  NewMessageController.swift
//  insta
//
//  Created by pop on 2/11/20.
//  Copyright © 2020 pop. All rights reserved.
// list of user

import UIKit
import Firebase

class NewMessageController: UITableViewController {

    var image:UIImage?
    let cellid = "cellID"
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(handlecancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellid)
        fetchuser()
    }
    
    func fetchuser(){
        let ref = FIRDatabase.database().reference().child("users")
        ref.observe(.childAdded) { (snapshot) in
            let dict = snapshot.value as? [String:Any]
            let user = User()
            user.name = dict!["name"] as? String
            user.email = dict!["email"] as? String
            user.profileimage = dict!["profileimage"] as? String
            user.uid = dict!["uid"] as? String
           // print(user.name,user.profileimage)
            self.users.append(user)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func handlecancel(){
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        var image2 = UIImage()
        cell.imageView?.contentMode = .scaleAspectFill
        DispatchQueue.global(qos: .userInteractive).async {
            if let url = user.profileimage{
                let storage = FIRStorage.storage()
                var reference: FIRStorageReference!
                reference = storage.reference(forURL: url)
                reference.downloadURL(completion: { (url, error) in
                    let data = NSData(contentsOf: url!)
                    image2 = UIImage(data: data! as Data)!
                   cell.profileimageview.image = image2
                })
            }
            
        }
        DispatchQueue.main.async {
            cell.textLabel?.text = user.name
            cell.detailTextLabel?.text = user.email
        }
        
        return cell
  }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    var viewcontroler:ViewController?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.viewcontroler?.ShowchatViewControllerForUser(user: user)
        }
    }
    


}

//
//  CellMessage.swift
//  insta
//
//  Created by pop on 2/12/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Firebase

/*class CellMessage: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var messageLB: UILabel!
    @IBOutlet weak var timeLB: UILabel!
    
}*/

class UserCell:UITableViewCell{
    
    var singlemessage:Message?{
        didSet{
           userwithprofileimage()
            detailTextLabel?.text = singlemessage?.message
            if let secnd = singlemessage?.timestamp?.doubleValue{
                let timestamp = NSDate(timeIntervalSince1970: secnd)
                let dateformate = DateFormatter()
                dateformate.dateFormat = "hh:mm:ss a"
                timelabel.text = dateformate.string(for: timestamp)
            }
            
            
        }
    }
    
    
    func userwithprofileimage(){
        var chatPartnerId : String?
        if  singlemessage?.fromid == FIRAuth.auth()?.currentUser?.uid {
            chatPartnerId = singlemessage?.toid
        }else{
            chatPartnerId = singlemessage?.fromid
        }
        if let toid = chatPartnerId{
            // FETCH:- specific user
            let ref = FIRDatabase.database().reference().child("users").child(toid)
            ref.observeSingleEvent(of: .value , with: { (snapshot) in
                let dict = snapshot.value as? [String:Any]
                self.textLabel?.text = dict!["name"] as? String
                if let url = dict!["profileimage"] as? String{
                    let storage = FIRStorage.storage()
                    var reference: FIRStorageReference!
                    reference = storage.reference(forURL: url)
                    reference.downloadURL(completion: { (url, error) in
                        let data = NSData(contentsOf: url!)
                        self.profileimageview.image = UIImage(data: data! as Data)!
                    })
                }
            })
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 56, y: ((textLabel?.frame.origin.y)! - 2), width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        detailTextLabel?.frame = CGRect(x: 56, y: ((detailTextLabel?.frame.origin.y)! + 2), width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
    }
    
    let profileimageview:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timelabel : UILabel={
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileimageview)
        addSubview(timelabel)
        //constrain label
        timelabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
       // timelabel.centerYAnchor.constraint(equalTo: (textLabel?.centerYAnchor)!).isActive = true
        timelabel.topAnchor.constraint(equalTo: self.topAnchor, constant : 15).isActive = true
        timelabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timelabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        // constaraint profileimage
        profileimageview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileimageview.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileimageview.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileimageview.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

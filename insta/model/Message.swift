//
//  Message.swift
//  insta
//
//  Created by pop on 2/12/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var message:String?
    var fromid:String?
    var toid:String?
    var timestamp:NSNumber?
    
    func chatPArtID()->String?{
  
        if fromid == FIRAuth.auth()?.currentUser?.uid {
           return toid
        }else{
           return fromid
        }
    }
}

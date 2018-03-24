//
//  MessagesVC.swift
//  Chat
//
//  Created by SherifShokry on 3/21/18.
//  Copyright © 2018 SherifShokry. All rights reserved.
//

import UIKit
import Firebase
class MessagesVC: UIViewController , UITextFieldDelegate , UITableViewDelegate , UITableViewDataSource {
  
    

    
        @IBOutlet weak var messagesTableView: UITableView!
        @IBOutlet weak var textHeightConstrain: NSLayoutConstraint!
        @IBOutlet weak var messageTextField: UITextField!
    
    
    
    
        var messagesArr : [Message] = []
        var sendById : String?
        var sendToId : String?
        var sendToName: String?
        var messageID : String = ""
        var numOfMessages : Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messageTextField.delegate = self
        print("myID = \(sendById!)")
        print("sendToID = \(sendToId!)")
      
       
        //UITapGestureRecognizer
        let tap =  UITapGestureRecognizer(target: self , action: #selector(textFieldDidEndEditing(_:)) )
        tap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tap)
        getMsgId()
      
      
        
      }
  

    
        func textFieldDidBeginEditing(_ textField: UITextField) {
           
            textHeightConstrain.constant = 310
             self.view.layoutIfNeeded()
            
        }
    
       func textFieldDidEndEditing(_ textField: UITextField)
       {
        messageTextField.isEnabled = false
        textHeightConstrain.constant = 38
        self.view.layoutIfNeeded()
         messageTextField.text = ""
         messageTextField.isEnabled = true
        }

    
    
    func createNewMessageId()
    {
        let ref = Database.database().reference()
    ref.child("header-message").child(sendById!).child(sendToId!).child("messageid").setValue(sendById! + sendToId!)
    ref.child("header-message").child(sendToId!).child(sendById!).child("messageid").setValue(sendById! + sendToId!)
      getMsgId()
    }
    
    
    func getMsgId()
    {
        let ref = Database.database().reference()
        ref.child("header-message").child(sendById!).child(sendToId!).observeSingleEvent(of: .value, with: {
            (snapshot) in
            let value =  snapshot.value as?  Dictionary<String,String>
            if value == nil  {
               
                self.createNewMessageId()
               
            }
            else {
                self.messageID = (value!["messageid"])!
                 self.getAllMsgs()
                 self.getNumOfMessages()
        }
       
    })
   
    }
    
    func getAllMsgs(){
        
        let ref = Database.database().reference()
        ref.child("messages").child(messageID).observe(DataEventType.value)
        {
            (snapshot) in
        
       if let result = snapshot.value as? NSArray
       {
           self.messagesArr = []
            for (value) in result {
                
            let msg = Message()
                let msgDictionary = value as! Dictionary<String,String>
            
                for (id,message) in msgDictionary {
             if  id == Auth.auth().currentUser?.uid
                {
                msg.userName = "me"
                }
                else {
                    msg.userName = self.sendToName!
                }
                    msg.message = message 
                }
                self.messagesArr.append(msg)
                self.messagesTableView.reloadData()
                    
                }
            }
       else {
        print("OMG")
            }
        }
    }
    
    
    func getNumOfMessages() {
        let ref = Database.database().reference()
        ref.child("messages").child(messageID).observe(DataEventType.value)
        {
            (snapshot) in
            if snapshot.value is NSNull
          {
            self.numOfMessages = 0
            }
          
            else {
               
                let value =  snapshot.value as?  [Dictionary<String,String>]
                if let count = value?.count {
                self.numOfMessages = (count)
                }
                
                }
           
        
        }
        
    }
    
    func sendMessage(_ message : String)
    {
        
        let ref = Database.database().reference()
        ref.child("messages").child(messageID).child( String(numOfMessages)).child(sendById!).setValue(message)
  
    }
    
    
    
        @IBAction func sendMsgBtnPressed(_ sender: Any)
        {
            if messageTextField.text == nil {
                
            }
            else
            {
            sendMessage(messageTextField.text!)
            messageTextField.text = ""
            }
        }

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return messagesArr.count
  
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messagesTableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessagesTableViewCell
       print("msgcount : \(messagesArr.count)")
        if messagesArr.count != 0 {
            print("msgcount : \(messagesArr.count)")
        cell?.messageLabel.text = messagesArr[indexPath.row].message
        cell?.userNameLabel.text = messagesArr[indexPath.row].userName
        }
        return cell!
    }
    
    
    
    
    
    
  
    
        @IBAction func backBtnPressed(_ sender: Any) {
           dismiss(animated: true, completion: nil)
        }
    
    
    
    
    
        @IBAction func logOutBtnPressed(_ sender: Any) {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                popUpLogInVC ()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
    
    
    
    
    
        func  popUpLogInVC () {
            let viewController = storyboard?.instantiateViewController(withIdentifier :"welcomeScreen")
            self.present(viewController!, animated: true)
        }
    
}

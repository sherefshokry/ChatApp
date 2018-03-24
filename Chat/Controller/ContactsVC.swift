//
//  ContactsVC.swift
//  Chat
//
//  Created by SherifShokry on 3/20/18.
//  Copyright © 2018 SherifShokry. All rights reserved.
//

import UIKit
import  Firebase


class ContactsVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
   

    @IBOutlet weak var contactTableView: UITableView!
    
    var myContacts : [User] = []
     var cellIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        contactTableView.delegate = self
        contactTableView.dataSource = self
        getMyContacts()
        // Do any additional setup after loading the view.
    }

    
    
    func  getMyContacts()
    {
       let ref = Database.database().reference()
        ref.child("users").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            for (userId,result) in value!
            {  let user : User = User()
                if userId as? String == Auth.auth().currentUser?.uid
                {
                   continue
                }
                else{
                
                 user.userId = userId as! String
                 let userInformation = result as? NSDictionary
            
              for (key,res) in userInformation!
              {
                  let  keyValue = key as! String
                     if  keyValue == "email"
                      {
                        user.userEmail =  res as! String
                        print("userEmail : \(user.userEmail)")
                      }
                    else
                     {
                      user.userName  =  res as! String
                      print("userName : \(user.userName)")
                     }
             }
                self.myContacts.append(user)
                self.contactTableView.reloadData()
                    
                }
              
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
   
   
    }
    

    
    
   //Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return myContacts.count
 
    }

  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactTableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! MyContactsTableViewCell
        
        if myContacts.count != 0 {
     cell.emailLabel.text = myContacts[indexPath.row].userEmail
     cell.userNameTextField.text = myContacts[indexPath.row].userName
        }
        return cell
    }

    
 
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    NSLog("You selected cell number: \(indexPath.row)!")
     cellIndex = indexPath.row
    self.performSegue(withIdentifier: "goToMessages", sender: self)
    }
    
   
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMessages"
        {
            if let destinationVC = segue.destination as? MessagesVC {
                destinationVC.sendById = Auth.auth().currentUser?.uid
                destinationVC.sendToId = myContacts[cellIndex].userId
                destinationVC.sendToName = myContacts[cellIndex].userName
            }
        }
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




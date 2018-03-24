//
//  RegisterVC.swift
//  Chat
//
//  Created by SherifShokry on 3/20/18.
//  Copyright © 2018 SherifShokry. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController
{

    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
 
    //create user object
    var user : User = User()
   
    override func viewDidLoad() {
        super.viewDidLoad()

      
 }


   
    @IBAction func registerBtnPressed(_ sender: Any)
    {
       createNewUser()
    }
  
    
    
    
    
    func createNewUser(){
   
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil
            {
               
                // create the alert
                let alert = UIAlertController(title: "My Title", message: error?.localizedDescription
                    , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
           
            }
            else {
                
                self.user.userId = (user?.uid)!
                self.user.userEmail = self.emailTextField.text!
                self.user.userName = self.userNameTextField.text!
                self.addUserToUserDB()
                self.popUpContactsVC ()
            }
            
        }
    }
    
    func addUserToUserDB()
    {
        let ref = Database.database().reference()
        ref.child("users").child(user.userId).child("name").setValue(user.userName)
        ref.child("users").child(user.userId).child("email").setValue(user.userEmail)
    }
    
    func  popUpContactsVC ()
    {
     if  let viewController = storyboard?.instantiateViewController(withIdentifier : "contactsViewController") as? ContactsVC
     {
        self.present(viewController, animated: true)
     }
   
    }
    

}

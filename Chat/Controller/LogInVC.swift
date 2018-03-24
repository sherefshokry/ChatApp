//
//  LogInVC.swift
//  Chat
//
//  Created by SherifShokry on 3/20/18.
//  Copyright © 2018 SherifShokry. All rights reserved.
//

import UIKit
import Firebase

class LogInVC: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func logInBtnPressed(_ sender: Any) {
  
    
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!)
        {
            (user, error) in
            if error != nil {
                
                // create the alert
                let alert = UIAlertController(title: "My Title", message: error?.localizedDescription
                    , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
             self.popUpContactsVC ()
            }
            
        }
        
    }
    func  popUpContactsVC () {
        let viewController = storyboard?.instantiateViewController(withIdentifier :"contactsViewController") as! ContactsVC
        self.present(viewController, animated: true)
    }
 
}

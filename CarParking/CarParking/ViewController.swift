//
//  ViewController.swift
//  CarParking
//
//  Created by Venkat 101287100 on 2021-01-24.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signin(_ sender: Any) {
        if (email.text == "" || password.text == ""){
                let alert = UIAlertController(title: "Login Unsuccessful", message: "Incorrect email or Password", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style:  .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            return
        }
        else{
            
            Auth.auth().signIn(withEmail: email.text!, password: password.text!) { AuthResult, Error in
                if Error != nil{
                    print(Error)
                }
                else
                {
                    print(AuthResult?.credential)
                    let alert = UIAlertController(title: "Login Successful", message: "you have logged in now", preferredStyle: .alert   )
                    
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: {_ in
                        
                        self.performSegue(withIdentifier: "signedIn", sender: self)
                    }))
                    
                    self.present(alert, animated:true, completion: nil)
                    
                }
            }
            
            
        }
        
    }
    
}


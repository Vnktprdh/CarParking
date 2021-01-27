//
//  AddUserViewController.swift
//  CarParking
//
//  Created by Mithun koroth on 2021-01-26.
//

import UIKit
import Firebase

class AddUserViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmpassword: UITextField!
    @IBOutlet weak var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createaccount(_ sender: Any) {
        if (email.text == "" || password.text == "" || confirmpassword.text == ""){
                let alert = UIAlertController(title: "Sign up Unsuccessful", message: "Incorrect email or Password", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style:  .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            return
        }
        else{
            if (password.text! != confirmpassword.text!)
            {
                let alert = UIAlertController(title: "Sign up Unsuccessful", message: " both passwords must be the same", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style:  .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            return
            }
            else{
                Auth.auth().createUser(withEmail: email.text!, password: password.text!) { Auth, Err in
                    if (Err != nil)
                    {
                        let alert = UIAlertController(title: "Sign up Unsuccessful", message: "try again!", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style:  .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    return
                    }
                    else{
                        let alert = UIAlertController(title: "Sign up successful", message: "account is created", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: {_ in
                            
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    return
                        
                    }
                }
                
                
                
            }
                
            }
            
            
        }
        
        
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

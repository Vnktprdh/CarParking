//
//  ProfileViewController.swift
//  CarParking
//
//  Created by Mithun koroth on 2021-01-26.
//
import Firebase
import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var email: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        email.text = "Email : \(Auth.auth().currentUser!.email!) "
    }
    
}

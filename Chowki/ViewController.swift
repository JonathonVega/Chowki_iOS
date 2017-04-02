//
//  ViewController.swift
//  Chowki
//
//  Created by Jonathon F Vega on 4/1/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var signupTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        checkForCurrentUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkForCurrentUser() {
        if FIRAuth.auth()?.currentUser != nil {
            self.performSegue(withIdentifier: "segueToApp", sender: self)
        }
    }

    @IBAction func initializeButton(_ sender: UIButton) {
        let email = signupTextField.text! + "@domain.com"
        let password = "password"
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "segueToApp", sender: self)
            } else {
                
                if let errCode = FIRAuthErrorCode(rawValue: (error as! NSError).code){
                    
                    // TODO: Need to fix errors through UI accordingly
                    switch errCode {
                    case .errorCodeInvalidEmail:
                        print("Invalid email")
                    case .errorCodeEmailAlreadyInUse:
                        print("Email already in use")
                        
                        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                            if user != nil {
                                self.performSegue(withIdentifier: "segueToApp", sender: self)
                                print(user!.uid)
                            }
                            else {
                                
                                if let errCode = FIRAuthErrorCode(rawValue: (error as! NSError).code){
                                    
                                    // TODO: Need to fix errors through UI accordingly
                                    switch errCode {
                                    case .errorCodeInvalidEmail:
                                        print("Invalid email")
                                    case .errorCodeWrongPassword:
                                        print("Password is wrong")
                                    case .errorCodeUserDisabled:
                                        print("User account is disabled")
                                    case .errorCodeUserNotFound:
                                        print("User account cannot be found")
                                    default:
                                        print("Wrong in some way!!!")
                                    }
                                }
                                
                                print(error!)
                                
                            }
                        })
                        
                    default:
                        print("Wrong in some way!!!")
                    }
                }
                
                print(error!)
                
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

}


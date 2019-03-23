//
//  LoginVC.swift
//  Rijks Museum Explorer iOS
//
//  Created by user151601 on 3/23/19.
//  Copyright © 2019 atn010.com. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	
	let userStatus = UserStatusSingleton.shared
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	
	@IBAction func loginClicked(_ sender: UIButton) {
		
		if attemptToLogin() {
			performSegue(withIdentifier: "toMain", sender: self)
		}
		
		
		
	}
	
	func showErrorMessage(message:String) {
		let loginFailedAlert = UIAlertController(title: "Login Failed", message: message, preferredStyle: UIAlertController.Style.alert)
		loginFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		self.present(loginFailedAlert,animated: true,completion: nil)
	}
	
	func attemptToLogin() -> Bool {
		
		guard let username = usernameTextField.text else {
			showErrorMessage(message: "Username should not be empty")
			return false
		}
		
		guard let password = passwordTextField.text else {
			showErrorMessage(message: "Password should not be empty")
			return false
		}
		
		
		if username.isEmpty {
			showErrorMessage(message: "Username should not be empty")
			return false
		}else if password.isEmpty{
			showErrorMessage(message: "Password should not be empty")
			return false
		}else if !userStatus.checkAccountValidity(username: username, password: password, loginAttempt: true){
			showErrorMessage(message: "Authentication failed")
			return false
		}
		
		
		
		return true
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

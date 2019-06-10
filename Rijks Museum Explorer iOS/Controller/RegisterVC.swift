//
//  RegisterVC.swift
//  Rijks Museum Explorer iOS
//
//  Created by user151601 on 3/23/19.
//  Copyright © 2019 atn010.com. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
	
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var acceptTermCondCheckBox: UIButton!
	
	var checkBoxStatus = false
	
	let userStatus = UserStatusSingleton.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		hideKeyboardWhenTappedAround()
    }
	
	func showErrorMessage(message:String) {
		let failureAlert = UIAlertController(title: "Register Failed", message: message, preferredStyle: UIAlertController.Style.alert)
		failureAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		self.present(failureAlert,animated: true,completion: nil)
	}

	@IBAction func checkBox(_ sender: UIButton) {
		if checkBoxStatus {
			checkBoxStatus = false
			acceptTermCondCheckBox.setImage(UIImage.init(named: "baseline_check_box_outline_blank_black_48pt_1x")!, for: .normal)
			
		}else {
			checkBoxStatus = true
			acceptTermCondCheckBox.setImage(UIImage.init(named: "baseline_check_box_black_48pt_1x")!, for: .normal)
		}
	}
	
	@IBAction func registerButtonClicked(_ sender: UIButton) {
		
		if attemptToRegister() {
			let registerAlertSuccess = UIAlertController(title: "Register Success", message: "Registration Complete\nTry logging in", preferredStyle: UIAlertController.Style.alert)
			registerAlertSuccess.addAction(UIAlertAction(title: "OK", style: .default, handler: { (clicked) in
				DispatchQueue.main.async {
					self.navigationController?.popViewController(animated: true)
				}
			}))
			self.present(registerAlertSuccess, animated: true, completion: nil)
			
		}
	
	}
	
	func attemptToRegister() -> Bool {
		
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
		}else if !checkBoxStatus{
			showErrorMessage(message: "Did not accept Term and Condition")
			return false
		}else if userStatus.checkAccountValidity(username: username, password: password, loginAttempt: false){
			showErrorMessage(message: "Authentication failed\nUser has already Registered")
			return false
		}
		
		
		
		return userStatus.registerNewAccount(username: username, password: password, image: nil)
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

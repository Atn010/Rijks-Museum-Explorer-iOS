//
//  SplashscreenVC.swift
//  Rijks Museum Explorer iOS
//
//  Created by user151601 on 3/22/19.
//  Copyright © 2019 atn010.com. All rights reserved.
//

import UIKit

class SplashscreenVC: UIViewController {
	let userStatus = UserStatusSingleton.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
			
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			if self.userStatus.getAccountFromCache() {
				self.toApp()
			}else{
			
			self.toLogin()
			}
		}
		
		
		
    }
	
	func toLogin(){
		performSegue(withIdentifier: "toLogin", sender: self)
	}
	
	func toApp(){
		performSegue(withIdentifier: "toApplication", sender: self)
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

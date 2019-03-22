//
//  ProfileVController.swift
//  Rijks Museum Explorer iOS
//
//  Created by user151601 on 3/22/19.
//  Copyright © 2019 atn010.com. All rights reserved.
//

import UIKit
import KYDrawerController

class ProfileVController: UIViewController {
	let userStatus = UserStatusSIngleton.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		userStatus.currentNavigationLevel = 1
    }
	
	@IBAction func openMenu(_ sender: UIBarButtonItem) {
		
		
		let drawer = self.navigationController?.parent as! KYDrawerController
		
		drawer.setDrawerState(.opened, animated: true)
		
		
	}
	
	func changeToHome(){
		performSegue(withIdentifier: "toHome", sender: self)
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

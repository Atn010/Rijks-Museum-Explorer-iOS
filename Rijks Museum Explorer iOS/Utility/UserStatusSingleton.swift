//
//  UserStatusSIngleton.swift
//  Rijks Museum Explorer iOS
//
//  Created by user151601 on 3/22/19.
//  Copyright © 2019 atn010.com. All rights reserved.
//

import UIKit

class UserStatusSingleton: NSObject {
	static let shared = UserStatusSingleton()
	
	var account = AccountStructure.init(username: "Guest", password: "Guest", image: nil)
	var currentNavigationLevel = 0
	
	private override init() {
		print("User Status Object initialized")
		
	}
	
	func updateCurrentAccountPicture(image:UIImage){
		var previousVersion = account
		account = AccountStructure.init(username: previousVersion.username, password: previousVersion.password, image: image)
	}
	
	func getAccountFromCache() -> Bool {
		let account = UserDefaults.standard.stringArray(forKey: "sessionAccount") ?? [String]()
		
		return true
		
		if account.count < 2{
			return false
		}
		
		if !checkAccountValidity(username: account.first!, password: account.last!){
			return false
		}
		
		return true
	}
	
	func checkAccountValidity(username:String, password:String) -> Bool {
		return true
	}
}

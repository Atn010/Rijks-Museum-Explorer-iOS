//
//  UserStatusSIngleton.swift
//  Rijks Museum Explorer iOS
//
//  Created by user151601 on 3/22/19.
//  Copyright © 2019 atn010.com. All rights reserved.
//

import UIKit
import CoreData

class UserStatusSingleton: NSObject {
	static let shared = UserStatusSingleton()
	
	
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	var managedObjectContext : NSManagedObjectContext!
	
	
	var account = AccountStructure.init(username: "Guest", password: "Guest", image: nil)
	var currentNavigationLevel = 0
	
	private override init() {
		print("User Status Object initialized")
		managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	}
	
	func updateCurrentAccountPicture(image:UIImage){
		let previousVersion = account
		account = AccountStructure.init(username: previousVersion.username, password: previousVersion.password, image: image)
	}
	
	func getAccountFromCache() -> Bool {
		let account = UserDefaults.standard.stringArray(forKey: "sessionAccount") ?? [String]()
		
		return true
		
		if account.count != 2{
			return false
		}
		
		if !checkAccountValidity(username: account.first!, password: account.last!){
			return false
		}
		
		return true
	}
	
	func checkAccountValidity(username:String, password:String) -> Bool {
		let noteRequest:NSFetchRequest<UserAccount> = UserAccount.fetchRequest()
		
		do {
			let result = try managedObjectContext.fetch(noteRequest)
			for data in result as [NSManagedObject] {
				
				
				let dbUser = data.value(forKey: "username") as! String
				let dbPass = data.value(forKey: "password") as! String
				let dbProfile = data.value(forKey: "profile") as? Data
				
				
				if dbUser == username && dbPass == password {
					
					var dbImage:UIImage?
					
					if let profilePicData = dbProfile{
						dbImage = UIImage.init(data: profilePicData)
					}
					
					account = AccountStructure.init(username: dbUser, password: dbPass, image: dbImage)
					saveSession(username: account.username, password: account.password)
					
					return true
				}
				
				
				
				
			}
			
			return false
			
		} catch {
			
			print("Failed Loading")
			return false
		}
	}
	
	
	func saveSession(username:String,password:String){
		
		let session = [username,password]
		UserDefaults.standard.set(session, forKey: "sessionAccount")
	}
	
	
	
	
}

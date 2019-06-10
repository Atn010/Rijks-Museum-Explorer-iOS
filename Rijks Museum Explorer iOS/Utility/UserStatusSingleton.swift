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
		
		let noteRequest:NSFetchRequest<UserAccount> = UserAccount.fetchRequest()
		
		do {
			let result = try managedObjectContext.fetch(noteRequest)
			for data in result as [NSManagedObject] {
				
				
				let dbUser = data.value(forKey: "username") as! String

				
				
				if dbUser == previousVersion.username{
					managedObjectContext.delete(data)
					do{
						try managedObjectContext.save()
					}catch{
						print("Failed Deletion")
						return
					}
					
                    if false == registerNewAccount(username: previousVersion.username, password: previousVersion.password, image: image) {
                        return
                    }
                    
					account = AccountStructure.init(username: previousVersion.username, password: previousVersion.password, image: image)
					return
				}
		
				
			}
			
			return
			
		} catch {
			
			print("Failed Loading")
			return
		}
		
	}
	
	func getAccountFromCache() -> Bool {
		let account = UserDefaults.standard.stringArray(forKey: "sessionAccount") ?? [String]()
		
		//return true
		
		if account.count != 2{
			return false
		}
		
		if !checkAccountValidity(username: account.first!, password: account.last!, loginAttempt: true){
			return false
		}
		
		return true
	}
	
	func checkAccountValidity(username:String, password:String, loginAttempt:Bool) -> Bool {
		let noteRequest:NSFetchRequest<UserAccount> = UserAccount.fetchRequest()
		
		do {
			let result = try managedObjectContext.fetch(noteRequest)
			for data in result as [NSManagedObject] {
				
				
				let dbUser = data.value(forKey: "username") as! String
				let dbPass = data.value(forKey: "password") as! String
				let dbProfile = data.value(forKey: "profile") as? Data
				
				
				if dbUser == username{
					
					if loginAttempt {
						var dbImage:UIImage?
						
						if let profilePicData = dbProfile{
							dbImage = UIImage.init(data: profilePicData)
						}
						
						account = AccountStructure.init(username: dbUser, password: dbPass, image: dbImage)
						saveSession(username: account.username, password: account.password)
					}
					
					return true
				}
				
				
				
				
			}
			
			return false
			
		} catch {
			
			print("Failed Loading")
			return false
		}
	}
	
	func registerNewAccount(username:String,password:String,image:UIImage?) -> Bool{
		let noteRequest:NSFetchRequest<UserAccount> = UserAccount.fetchRequest()
		var count = 0
		
		do {
			let result = try managedObjectContext.fetch(noteRequest)
			for data in result as [NSManagedObject] {
				if data.value(forKey: "username") as! String == username{
					count += 1
				}
				
				
			}
			
			if count == 0{
				
				let Acc = UserAccount(context: managedObjectContext)
				
				Acc.username = username
				Acc.password = password
				
				if let profileImage = image {
					Acc.profile = profileImage.jpegData(compressionQuality: 0.1)
				}else {
					Acc.profile = nil
				}
				
				
				do{
					try self.managedObjectContext.save()
					return true
				}catch{
					return false
				}
				
			}
			
		} catch {
			
			print("Failed Reading")
			return false
		}
		
		return false
	}

	
	
	func saveSession(username:String,password:String){
		
		let session = [username,password]
		UserDefaults.standard.set(session, forKey: "sessionAccount")
	}
	
	func removeSession(){
		account = .init(username: "Guest", password: "Guest", image: nil)
		UserDefaults.standard.removeObject(forKey: "sessionAccount")
	}
	
	
}

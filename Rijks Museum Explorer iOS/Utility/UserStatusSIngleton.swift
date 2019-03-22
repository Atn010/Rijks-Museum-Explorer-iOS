//
//  UserStatusSIngleton.swift
//  Rijks Museum Explorer iOS
//
//  Created by user151601 on 3/22/19.
//  Copyright © 2019 atn010.com. All rights reserved.
//

import UIKit

class UserStatusSIngleton: NSObject {
	static let shared = UserStatusSIngleton()
	
	var currentNavigationLevel = 0
	
	private override init() {
		print("User Status Object initialized")
		
	}
}

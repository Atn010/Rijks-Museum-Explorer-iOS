//
//  AccountStructure.swift
//  Rijks Museum Explorer iOS
//
//  Created by user151601 on 3/21/19.
//  Copyright © 2019 atn010.com. All rights reserved.
//

import UIKit

class AccountStructure{
	var username:String
	var password:String
	var image:UIImage?
	
	init(username:String, password:String, image:UIImage?) {
		self.username = username
		self.password = password
		self.image = image
	}
	
}

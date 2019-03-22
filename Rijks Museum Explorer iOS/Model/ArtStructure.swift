//
//  ArtStructure.swift
//  Rijks Museum Explorer iOS
//
//  Created by user151601 on 3/21/19.
//  Copyright © 2019 atn010.com. All rights reserved.
//

import Foundation

class ArtStructure{
	var id:String
	var name:String
	var imageURL: URL?
	
	init(id:String, name:String, imageURL:URL?) {
		self.id = id
		self.name = name
		self.imageURL = imageURL
	}
}

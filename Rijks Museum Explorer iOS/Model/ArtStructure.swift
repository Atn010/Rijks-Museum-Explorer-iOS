//
//  ArtStructure.swift
//  Rijks Museum Explorer iOS
//
//  Created by user151601 on 3/21/19.
//  Copyright © 2019 atn010.com. All rights reserved.
//

import Foundation

class ArtStructure: Hashable{
	var id:String
	var shortName:String
	var longName:String
	var imageURL: URL?
	
	init(id:String, shortName:String, longName:String, imageURL:URL?) {
		self.id = id
		self.shortName = shortName
		self.longName = longName
		self.imageURL = imageURL
	}
	
	static func == (lhs: ArtStructure, rhs: ArtStructure) -> Bool {
		return lhs.id == rhs.id &&
			lhs.shortName == rhs.shortName &&
			lhs.longName == rhs.longName &&
			lhs.imageURL == rhs.imageURL
	}

	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(shortName)
		hasher.combine(longName)
		hasher.combine(imageURL)
	}
	
}

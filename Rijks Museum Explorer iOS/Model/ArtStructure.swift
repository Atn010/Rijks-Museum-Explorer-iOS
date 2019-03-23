//
//  ArtStructure.swift
//  Rijks Museum Explorer iOS
//
//  Created by user151601 on 3/21/19.
//  Copyright © 2019 atn010.com. All rights reserved.
//

import UIKit
import DeepDiff

class ArtStructure: DiffAware{
	var diffId: Int
	
	var id:String
	var shortName:String
	var longName:String
	var imageURL: URL?
	
	init(id:String, shortName:String, longName:String, imageURL:URL?) {
		self.id = id
		self.shortName = shortName
		self.longName = longName
		self.imageURL = imageURL
		diffId = longName.count * id.count * shortName.count
	}

	static func compareContent(_ a: ArtStructure, _ b: ArtStructure) -> Bool {
		return a.id == b.id &&
			a.shortName == b.shortName &&
			a.longName == b.longName &&
			a.imageURL == b.imageURL
	}
	
}

class ArtDetailStructure{
	var id:String
	var description:String
	
	init(id:String, description:String) {
		self.id = id
		self.description = description
	}
}

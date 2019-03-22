//
//  ArtObjects.swift
//  Rijks Museum Explorer iOS
//
//  Created by user151601 on 3/21/19.
//  Copyright © 2019 atn010.com. All rights reserved.
//

import UIKit

class ArtObjects: NSObject {
	static let shared = ArtObjects()
	
	var pagination = 1
	var artList = [ArtStructure]()
	
	let listURLString = "https://www.rijksmuseum.nl/api/en/collection?key=eIZdWWCT&format=json&imgonly=true&p="
	
	let detailURLStringPre = "https://www.rijksmuseum.nl/api/en/collection/"
	let detailURLStringPos = "?key=eIZdWWCT&format=json"
	
	private override init() {
		print("Arts Object initialized")
		
	}
	
}

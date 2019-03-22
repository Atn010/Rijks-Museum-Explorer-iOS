//
//  ArtObjects.swift
//  Rijks Museum Explorer iOS
//
//  Created by user151601 on 3/21/19.
//  Copyright © 2019 atn010.com. All rights reserved.
//

import UIKit
import Alamofire

class ArtObjects: NSObject {
	static let shared = ArtObjects()
	
	var pagination = 1
	var artList = [ArtStructure]()
	
	private override init() {
		print("News Object initialized")
		
	}
	
}

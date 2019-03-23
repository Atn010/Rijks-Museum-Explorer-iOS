//
//  ArtDetailTVController.swift
//  Rijks Museum Explorer iOS
//
//  Created by user151601 on 3/22/19.
//  Copyright © 2019 atn010.com. All rights reserved.
//

import UIKit
import Kingfisher

class ArtDetailTVController: UITableViewController {
	
	@IBOutlet weak var artImage: UIImageView!
	@IBOutlet weak var artLongTitle: UILabel!
	@IBOutlet weak var artDescription: UITextView!
	
	let userStatus = UserStatusSingleton.shared
	let artObject = ArtObjects.shared
	
	let urlPre = "https://www.rijksmuseum.nl/api/en/collection/"
	let urlPost = "?key=eIZdWWCT&format=json"
	
	var index = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem
		loadArtDetail()
		DispatchQueue.main.async {
			
			
			self.artImage.kf.indicatorType = .activity
			self.artImage.kf.setImage(
				with: self.artObject.artList[self.index].imageURL,
				placeholder: UIImage.init(color: .white),
				options: [
					.transition(.fade(1))
				])
			{
				result in
				switch result {
				case .success( _):
					print("Yey")
				case .failure( _):
					print("Nay")
				}
			}
			UIView.setAnimationsEnabled(false)
			self.tableView.beginUpdates()
			
			self.artLongTitle.text = self.artObject.artList[self.index].longName
			
			self.tableView.endUpdates()
			UIView.setAnimationsEnabled(true)
		}
	}
	
	fileprivate func loadFromMemory() -> Bool {
		var exist = false
		artObject.artDetails.forEach { (cachedDetails) in
			if cachedDetails.id == self.artObject.artList[self.index].id {
				exist =  true
				DispatchQueue.main.async {
					UIView.setAnimationsEnabled(false)
					self.tableView.beginUpdates()
					
					self.artDescription.text = cachedDetails.description
					
					self.tableView.endUpdates()
					UIView.setAnimationsEnabled(true)
					
				}

			}
		}
		return exist
	}
	
	func loadArtDetail(){
		
		if !loadFromMemory() {
			loadDataDetail(dataURLString: "\(urlPre)\(self.artObject.artList[self.index].id)\(urlPost)") { (isSuccess, Detail) in
				if isSuccess{
					self.artObject.artDetails.append(Detail)
					DispatchQueue.main.async {
						UIView.setAnimationsEnabled(false)
						self.tableView.beginUpdates()
						
						self.artDescription.text = Detail.description
						
						self.tableView.endUpdates()
						UIView.setAnimationsEnabled(true)
						return
					}
					
				}
			}
		}
	}
	
	
}

extension ArtDetailTVController {
	func loadDataDetail(dataURLString:String,completion: @escaping (_ isSuccess:Bool, _ artDetail:ArtDetailStructure)-> ()) {
		var artDetail = ArtDetailStructure.init(id: "-", description: "")
		
		guard let rateURL = URL(string: dataURLString) else {
			completion(false,artDetail)
			return
		}
		
		let session = URLSession.shared
		
		let dataTask = session.dataTask(with: rateURL) { (data, response, error) in
			
			if let unwrapperError = error{
				print("URLSession Error = /n \(unwrapperError.localizedDescription)")
				
				completion(false,artDetail)
				return
				
			}else if let unwrappedData = data{
				do{
					
					let jsonFile = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
					
					guard let jsonDictionary = jsonFile as? [String:Any] else {
						completion(false,artDetail)
						print("failed")
						return
					}
					
					
					guard let jsonTop = jsonDictionary["artObject"] as? [String:Any] else {
						print("Maybe this")
						completion(false,artDetail)
						return
					}
					
					
					
					
					print(jsonTop["objectNumber"] ?? "failed")
					print(jsonTop["plaqueDescriptionEnglish"] ?? "failing1")
					
					
					
					
					guard let aID = jsonTop["objectNumber"] as? String else { completion(false,artDetail); return}
					guard let aDesc = jsonTop["plaqueDescriptionEnglish"] as? String else { completion(false,artDetail); return}
					
					
					
					
					artDetail = ArtDetailStructure.init(id: aID, description: aDesc)
					
					
					
					completion(true,artDetail)
					return
					
					
					
					
					
				}catch{
					print("Error Converting code")
					completion(false,artDetail)
					return
					
				}
				
				
				
			}
			
		}
		
		dataTask.resume()
	}
}

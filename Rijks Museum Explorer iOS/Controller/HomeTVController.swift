//
//  HomeTVController.swift
//  Rijks Museum Explorer iOS
//
//  Created by user151601 on 3/21/19.
//  Copyright © 2019 atn010.com. All rights reserved.
//

import UIKit
import KYDrawerController
import Kingfisher

class HomeTVController: UITableViewController {
	
	let userStatus = UserStatusSIngleton.shared
	let artObject = ArtObjects.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		userStatus.currentNavigationLevel = 0
		
		if artObject.artList.isEmpty {
			loadDataList(dataURLString: "\(artObject.listURLString)\(artObject.pagination)") { (sucess, newArt) in
				self.artObject.pagination += 1
				self.artObject.artList = newArt
			}
		}
		
    }
	
	@IBAction func openMenu(_ sender: UIBarButtonItem) {

		
		let drawer = self.navigationController?.parent as! KYDrawerController
		
		drawer.setDrawerState(.opened, animated: true)
		
		
	}
	
	func changeToProfile(){
		performSegue(withIdentifier: "toProfile", sender: self)
	}
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return artObject.artList.count
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeTVCell
		
		cell.artImage.kf.indicatorType = .activity
		cell.artImage.kf.setImage(
			with: artObject.artList[indexPath.row].imageURL,
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
		
		cell.artName.text = artObject.artList[indexPath.row].shortName

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeTVController {
	func loadDataList(dataURLString:String,completion: @escaping (_ isSuccess:Bool, _ artList:[ArtStructure])-> ()) {
		var artListItems = [ArtStructure]()
		
		guard let rateURL = URL(string: dataURLString) else {
			completion(false,artListItems)
			return
		}
		
		let session = URLSession.shared
		
		let dataTask = session.dataTask(with: rateURL) { (data, response, error) in
			
			if let unwrapperError = error{
				print("URLSession Error = /n \(unwrapperError.localizedDescription)")
				
				completion(false,artListItems)
				return
				
			}else if let unwrappedData = data{
				do{
					
					let jsonFile = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
					
					guard let jsonDictionary = jsonFile as? [String:Any] else {
						completion(false,artListItems)
						print("failed")
						return
					}
					
					
					guard let jsonTop = jsonDictionary["artObjects"] as? [[String:Any]] else {
						print("Maybe this")
						completion(false,artListItems)
						return
					}
					
					
					
					var count = 0
					jsonTop.forEach({ (artItem) in
						print(count)
						print(artItem["id"] ?? "failed")
						print(artItem["title"] ?? "failing1")
						print(artItem["longTitle"] ?? "failing2")
						
						
						
						guard let webImage = artItem["webImage"] as? [String:Any] else {
							print("NoLoad")
							completion(false,artListItems)
							return
						}
						print(webImage["url"] ?? "NoLoad")
						
						
						
						guard let aID = artItem["id"] as? String else { completion(false,artListItems); return}
						guard let aTitle = artItem["title"] as? String else { completion(false,artListItems); return}
						guard let aLongTitle = artItem["longTitle"] as? String else { completion(false,artListItems); return}
						guard let aImageURL = webImage["url"] as? String else { completion(false,artListItems); return}
						
						
						
						
						let newArt = ArtStructure.init(id: aID, shortName: aTitle, longName: aLongTitle, imageURL: URL.init(string: aImageURL))

						artListItems.append(newArt)

						count += 1
					})
					
					completion(true,artListItems)
					return
					
					
					
					
					
				}catch{
					print("Error Converting code")
					completion(false,artListItems)
					return
					
				}
				
				
				
			}
			
		}
		
		dataTask.resume()
	}
}

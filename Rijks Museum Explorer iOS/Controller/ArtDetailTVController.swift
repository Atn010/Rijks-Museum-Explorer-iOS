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
	
	let userStatus = UserStatusSingleton.shared
	let artObject = ArtObjects.shared
	
	var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		
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

    // MARK: - Table view data source

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

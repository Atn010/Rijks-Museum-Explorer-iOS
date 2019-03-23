//
//  DrawerMenuTVController.swift
//  Rijks Museum Explorer iOS
//
//  Created by user151601 on 3/22/19.
//  Copyright © 2019 atn010.com. All rights reserved.
//

import UIKit
import KYDrawerController

class DrawerMenuTVController: UITableViewController {

	@IBOutlet weak var homeDrawerItem: UITableViewCell!
	@IBOutlet weak var profileDrawerItem: UITableViewCell!
	
	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var greetings: UILabel!
	
	let userStatus = UserStatusSingleton.shared
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		
	
		
		
		print("Init Drawer")
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		let account = userStatus.account
		greetings.text = "Hello, \(account.username)"
		if let profilePic =  account.image{
			profileImage.image = profilePic
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let drawer = self.parent as! KYDrawerController
		
		
		
		if indexPath.row == 1{
			if userStatus.currentNavigationLevel == 1{
				drawer.mainSegueIdentifier = "main1"
				
				
				let newMain:UINavigationController = UIStoryboard(name: "ArtExplore", bundle: nil).instantiateViewController(withIdentifier: "Home") as! UINavigationController
				
				drawer.mainViewController.dismiss(animated: false, completion: nil)
				drawer.mainViewController = newMain
				
			}

			
			drawer.setDrawerState(.closed, animated: true)
		}else if indexPath.row == 2{
			if userStatus.currentNavigationLevel == 0{
				drawer.mainSegueIdentifier = "main2"
				
				
				//let oldVCNavBar = drawer.mainViewController as! UINavigationController
				//oldVCNavBar.popToRootViewController(animated: false)
				
				
				let newMain:UINavigationController = UIStoryboard(name: "ArtExplore", bundle: nil).instantiateViewController(withIdentifier: "Profile") as! UINavigationController
				
				drawer.mainViewController.dismiss(animated: false, completion: nil)
				drawer.mainViewController = newMain
				
				print("goingtoProfile?")
				
			}
			
			drawer.setDrawerState(.closed, animated: true)
			
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

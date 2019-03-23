//
//  ProfileVController.swift
//  Rijks Museum Explorer iOS
//
//  Created by user151601 on 3/22/19.
//  Copyright © 2019 atn010.com. All rights reserved.
//

import UIKit
import KYDrawerController

class ProfileVController: UIViewController {
	let userStatus = UserStatusSingleton.shared

	@IBOutlet weak var profilePicture: UIImageView!
	@IBOutlet weak var userName: UILabel!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		userStatus.currentNavigationLevel = 1
		
		AddUITapGestureToImageView()

			self.profilePicture.layer.cornerRadius = self.profilePicture.frame.height / 2
		
		userName.text = userStatus.account.username
		
		print("Here in Profile\n\n\n")
    }
	
	@IBAction func openMenu(_ sender: UIBarButtonItem) {
		
		
		let drawer = self.navigationController?.parent as! KYDrawerController
		
		drawer.setDrawerState(.opened, animated: true)
		
		
	}
	
	@IBAction func logOutClicked(_ sender: UIButton) {
		let mainStoryBoard = UIStoryboard(name: "LoginRegister", bundle: nil)
		let newRoot = mainStoryBoard.instantiateInitialViewController()!
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.window?.rootViewController = newRoot
		
		userStatus.removeSession()
		performSegue(withIdentifier: "toLogin", sender: self)
		
	}
	
	func AddUITapGestureToImageView(){
		
		let tapImageVIew = UITapGestureRecognizer(target: self, action: #selector(onClick))
		self.profilePicture.addGestureRecognizer(tapImageVIew)
		
		
		profilePicture.isUserInteractionEnabled = true
	}
	
	@objc func onClick(){
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
			self.openCamera(self)
		}))
		
		alert.addAction(UIAlertAction(title: "Photos", style: .default, handler: { _ in
			self.openPhotos(self)
		}))
		
		alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
		
		self.present(alert, animated: true, completion: nil)
	}
	
	@IBAction func openPhotos(_ sender: Any) {
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		
		imagePickerController.sourceType = .photoLibrary
		self.present(imagePickerController,animated: true,completion: nil)
		
	}
	@IBAction func openCamera(_ sender: Any) {
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		
		if UIImagePickerController.isSourceTypeAvailable(.camera)
		{
			imagePickerController.sourceType = .camera
			self.present(imagePickerController,animated: true,completion: nil)
			
		} else
			
			//using camera in MAC IS NOT AVAILABLE
		{
			print("Camera not available")
		}
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileVController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		//         The info dictionary may contain multiple representations of the image. You want to use the original.
		guard let selectedImage = info[.originalImage] as? UIImage else {
			fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
		}
		

		userStatus.updateCurrentAccountPicture(image: selectedImage)
		self.profilePicture.image = selectedImage
		//Dismiss the picker.
		dismiss(animated: true, completion: nil)
	}
}

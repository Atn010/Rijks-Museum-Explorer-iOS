//
//  HomeTVController.swift
//  Rijks Museum Explorer iOS
//
//  Created by user151601 on 3/21/19.
//  Copyright © 2019 atn010.com. All rights reserved.
//

import UIKit
import Kingfisher
import DeepDiff
import RxSwift
import RxCocoa

class HomeTVController: UIViewController {
	
    @IBOutlet weak var artTable: UITableView!
    
    let userStatus = UserStatusSingleton.shared
	let artObject = ArtObjects.shared
	
	var selectedIndex = 0
	var isOffline = false
    
    public var arts = PublishSubject<[ArtStructure]>()
    private let disposeBag = DisposeBag()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		print("Home")
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem

        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        artTable.delegate = self
        artTable.dataSource = self
        
        artTable.register(UINib(nibName: "ArtCell", bundle: nil), forCellReuseIdentifier: "Cell")
		
		NotificationCenter.default.addObserver(self, selector: #selector(HomeTVController.networkStatusChanged(_:)), name: NSNotification.Name(ReachabilityStatusChangedNotification), object: nil )
		NetworkHelper().monitorReachabilityChanges()
		
		switch NetworkHelper().connectionStatus() {
		case .offline:
			isOffline = true
			break;
		case .online(_), .unknown:
			isOffline = false
			break;
		}
		
		if !userStatus.getAccountFromCache(){
			performSegue(withIdentifier: "toLogin", sender: self)
		}else{
			
			userStatus.currentNavigationLevel = 0
			
			if artObject.artList.isEmpty {
				initializeArtObjects()
			}
		}
		
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		NotificationCenter.default.removeObserver(self)
	}
	
	fileprivate func initializeArtObjects() {
		loadDataList(dataURLString: "\(artObject.listURLString)\(artObject.pagination)") { (sucess, newArt) in
			if sucess{
				let newItems:[ArtStructure] = newArt
				self.artObject.pagination += 1
				
				
				let changes = diff(old: self.artObject.artList, new: newItems)
				//self.programList = tempKegiatan
				
				DispatchQueue.main.async {
                    self.artTable.reload(changes: changes, section: 0, insertionAnimation: .fade, deletionAnimation: .fade, replacementAnimation: .fade, updateData: {
						self.artObject.artList = newItems
						
					}, completion: { (item) in
						self.artObject.pagination += 1
					})
					
					
				}
			}
			
			
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? ArtDetailTVController {
			vc.index = selectedIndex
		}
	}
		
}

extension HomeTVController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artObject.artList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "toDetail", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ArtCell
        
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == artObject.artList.count-1 && !isOffline {
            loadDataList(dataURLString: "\(artObject.listURLString)\(artObject.pagination)") { (sucess, newArt) in
                
                if sucess{
                    
                    var newItems:[ArtStructure] = self.artObject.artList
                    
                    newItems.append(contentsOf: newArt)
                    
                    self.artObject.pagination += 1
                    
                    
                    let changes = diff(old: self.artObject.artList, new: newItems)
                    //self.programList = tempKegiatan
                    
                    DispatchQueue.main.async {
                        self.artTable.reload(changes: changes, section: 0, insertionAnimation: .fade, deletionAnimation: .fade, replacementAnimation: .fade, updateData: {
                            self.artObject.artList = newItems
                            
                        }, completion: { (item) in
                            self.artObject.pagination += 1
                        })
                        
                        
                    }
                }
                
            }
            
        }
    }
}

extension HomeTVController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.navigationController?.viewControllers.count ?? 0 > 1
    }
}


extension HomeTVController {
	@objc func networkStatusChanged(_ notification: NSNotification ) {
		let status = NetworkHelper().connectionStatus()
		print(status)
		switch status {
		case .offline:
			isOffline = true
			let offlineAlert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertController.Style.alert)
			offlineAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			self.present(offlineAlert,animated: true,completion: nil)
			break;
		case .online(.wwan),.unknown, .online(.wiFi):
			isOffline = false
				DispatchQueue.main.async {
					self.artTable.reloadData()
				}
			
			break;
		}
		
	}
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
						print(artItem["objectNumber"] ?? "failed")
						print(artItem["title"] ?? "failing1")
						print(artItem["longTitle"] ?? "failing2")
						
						
						
						guard let webImage = artItem["webImage"] as? [String:Any] else {
							print("NoLoad")
							completion(false,artListItems)
							return
						}
						print(webImage["url"] ?? "NoLoad")
						
						
						
						guard let aID = artItem["objectNumber"] as? String else { completion(false,artListItems); return}
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

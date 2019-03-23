//
//  FadeSegue.swift
//  Rijks Museum Explorer iOS
//
//  Created by user151601 on 3/22/19.
//  Copyright © 2019 atn010.com. All rights reserved.
//

import UIKit

class FadeSegue: UIStoryboardSegue {
	override func perform() {
		
		guard let destinationView = self.destination.view else {
			// Fallback to no fading
			self.source.present(self.destination, animated: false, completion: nil)
			return
		}
		
		destinationView.alpha = 0
		self.source.view?.addSubview(destinationView)
		
		UIView.animate(withDuration: CATransaction.animationDuration(), animations: {
			destinationView.alpha = 1
		}, completion: { _ in
			self.source.present(self.destination, animated: false, completion: nil)
		})
	}
}

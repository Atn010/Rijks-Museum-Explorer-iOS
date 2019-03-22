//
//  HomeTVCell.swift
//  Rijks Museum Explorer iOS
//
//  Created by user151601 on 3/21/19.
//  Copyright © 2019 atn010.com. All rights reserved.
//

import UIKit
import Kingfisher

class HomeTVCell: UITableViewCell {

	@IBOutlet weak var artImage: UIImageView!
	@IBOutlet weak var artName: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		//mainImageView.af_cancelImageRequest() // NOTE: - Using AlamofireImage
		artImage.kf.cancelDownloadTask()
		artImage.image = nil
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

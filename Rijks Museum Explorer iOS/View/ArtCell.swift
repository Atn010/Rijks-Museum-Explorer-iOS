//
//  ArtCell.swift
//  Rijks Museum Explorer iOS
//
//  Created by TADA on 12/06/19.
//  Copyright © 2019 atn010.com. All rights reserved.
//

import UIKit
import Kingfisher

class ArtCell: UITableViewCell {

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

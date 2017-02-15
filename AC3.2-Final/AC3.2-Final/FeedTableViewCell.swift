//
//  FeedTableViewCell.swift
//  AC3.2-Final
//
//  Created by Ana Ma on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    let cellIdentifier = "feedTableViewCellIdentifier"
    
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var feedTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        self.feedImageView.image = nil
    }
}

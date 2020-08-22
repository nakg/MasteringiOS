//
//  CustomHeaderView.swift
//  TableView
//
//  Created by Nakjin Kim on 2020/06/15.
//  Copyright © 2020 Keun young Kim. All rights reserved.
//

import UIKit

class CustomHeaderView: UITableViewHeaderFooterView {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var countLabel: UILabel!
	@IBOutlet weak var customBackgroundView: UIView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		countLabel.text = "0"
		countLabel.layer.cornerRadius = 30
		countLabel.clipsToBounds = true
		
		backgroundView = customBackgroundView
	}

}

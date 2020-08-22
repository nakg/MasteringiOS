//
//  ColorCollectionViewCell.swift
//  CollectionView
//
//  Created by Nakjin Kim on 2020/03/07.
//  Copyright © 2020 Keun young Kim. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var colorView: UIView!
	@IBOutlet weak var hexLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	
	// 스토리보드에서 불가능한 초기화작업은, 대부분 이 메서드를 오버라이딩 하고 구현한다.
	override func awakeFromNib() {
		super.awakeFromNib()
		colorView.clipsToBounds = true
		colorView.layer.cornerRadius = colorView.bounds.width / 2
	}
}


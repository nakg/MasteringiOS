//
//  Copyright (c) 2018 KxCoding <kky0317@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

class FlowLayoutViewController: UIViewController {
	
	@IBOutlet weak var listCollectionView: UICollectionView!
	
	let list = MaterialColorDataSource.generateMultiSectionData()
	
	@objc func toggleScrollDirection() {
		guard let layout = listCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
			return
		}
		layout.scrollDirection = layout.scrollDirection == .vertical ? .horizontal : .vertical
		
		// 애니메이션 생성
		listCollectionView.performBatchUpdates({
			layout.scrollDirection = layout.scrollDirection == .vertical ? .horizontal : .vertical
		}, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Toggle", style: .plain, target: self, action: #selector(toggleScrollDirection))
		
		// 타입 캐스팅이 필요하다.
		if let layout = listCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			layout.itemSize = CGSize(width: 100, height: 100)
			layout.minimumInteritemSpacing = 5
			layout.minimumLineSpacing = 5
			
			layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		}
	}
}



extension FlowLayoutViewController: UICollectionViewDelegateFlowLayout {
	// collection view가 cell을 배치하기 전에, 크기를 설정하기 위하여. 다른 크기설정보다 우선순위가 높다. 현재 설정된 레이아웃 속성이 두번째 파라미터로 전달되고, 마지막 파라미터를 통해 cell 위치를 확인할 수 있다.
	// collectionview는 네비게이션 바와 겹치지 않도록, 탑여백을 자동으로 추가한다. 따라서 첫번째 라인에 추가되는 cell은 그만큼 내려와서 출력된다. cell높이를 계산하려면, 실제 높이에서 추가된 여백을 빼고 계산하여야한다.
	// 하단에 sectioninset이나 spacing 값들은, 델리게이트에서 호출한 값이 아닌 뷰디드로드에서 선언한 값이 사용된다. (왜냐하면 cell 만들때 먼저 이 메서드가 호출되고, 아래 있는 3개의 메서드는 더 늦게 호출되므로. 따라서, 아래 메서드가 아닌  뷰디드로드에서 값을 제대로 셋팅하거나 바로밑에 주석되어있는 itemSpaicng값에 실제로 델리게이트 호출해서 값 끌어와서 사용해야한다.셀 크기 결정 메서드가 제일 먼저 호출되므로. 위 두가지 방법 중 사용할 것.
	// 소수부분은 또 처리가 안됨.
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
//		let itemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: indexPath.section)
		
		print(indexPath.section, "#1", #function)
		guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
			return CGSize.zero
		}
		var bounds = collectionView.bounds
		bounds.size.height += bounds.origin.y
		
		var width = bounds.width - (layout.sectionInset.left + layout.sectionInset.right)
		var height = bounds.height - (layout.sectionInset.top + layout.sectionInset.bottom)
		
		switch layout.scrollDirection {
		case .vertical:
			height = (height - (layout.minimumLineSpacing * 4)) / 5
			if indexPath.item > 0 {
				width = (width - (layout.minimumInteritemSpacing * 2)) / 3
			}
		case .horizontal:
			width = (width - (layout.minimumLineSpacing * 2)) / 3
			if indexPath.item > 0 {
				height = (height - (layout.minimumInteritemSpacing * 4)) / 5
			}
		}
		// cell크기를 직접 계산할때는 소수점 오차를 고려하여야 한다. 아래는 버림 처리.
		return CGSize(width: width.rounded(.down), height: height.rounded(.down))
	}
	
	// cell 여백 값이 필요할 때 마다 이 메서드를 호출. 포인트값을 리턴한다.(spacing) cell 여백은 개별로 지정할 수 없고, 나중에 secion을통해 한번에 지정 할 수 있다.
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		print(section, "#2", #function)
		return 5
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		print(section, "#3", #function)
		return 5
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		print(section, "#4", #function)
		return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
	}
}



extension FlowLayoutViewController: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return list.count
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return list[section].colors.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
		cell.contentView.backgroundColor = list[indexPath.section].colors[indexPath.row]
		
		return cell
	}
}

















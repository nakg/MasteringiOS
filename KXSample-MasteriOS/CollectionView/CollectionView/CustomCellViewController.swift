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

class CustomCellViewController: UIViewController {
	
	let list = MaterialColorDataSource.generateSingleSectionData()
	
	@IBOutlet weak var listCollectionView: UICollectionView!
	
	// 세그웨이 이동할 때, 세그웨이 시행되기 전에 호출된다. 첫번째 파라미터로, 그다음 세그웨이 접근. 두번째 파라미터에는 세그웨이 시행시킨 객체가 전달된다. 예를들어 touch cell -> 이 셀을통해 인덱스페스를 얻고, 배열에서 몇번째가 선택되었는지 판단하여야 한다.
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// 타입캐스팅
		guard let cell = sender as? UICollectionViewCell else {
			return
		}
		
		// 얻은 인덱스페스로 리스트배열에서 대상을 가져오기.
		guard let indexPath = listCollectionView.indexPath(for: cell) else {
			return
		}
		
		let target = list[indexPath.item]
		
		segue.destination.view.backgroundColor = target.color
		segue.destination.title = target.title
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		 현재 컬렉션뷰에 표시되고있는 셀목록을 배열로 리턴한다.
//		listCollectionView.visibleCells
//
//		 특정위치에있는 cell 불러오기. 존재하지 않으면 nill이 리턴된다.
//		listCollectionView.cellForItem(at: <#T##IndexPath#>)
//
//		 셀위치를 확인할 때.
//		listCollectionView.indexPath(for: <#T##UICollectionViewCell#>)
//
//		 특정위치에 indexpath를 리턴. 주로 특정위치에 팬제스쳐통해 셀위치 변경할 때 사용한다.
//		listCollectionView.indexPathForItem(at: CGPoint)
//
//		// 컬렉션뷰에 표시되어있는 셀의 인덱스페스 얻음
//		listCollectionView.indexPathsForVisibleItems
//
//		// 선택된 셀의 인덱스페스 얻음
//		listCollectionView.indexPathsForSelectedItems
	}
}

extension CustomCellViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return list.count
	}
	
	// 구현한 cell을 직접 사용하기 위해서는, 새로만든 컬렉션뷰 셀 타입으로 타입 캐스팅하면서 넣어주어야 한다.
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ColorCollectionViewCell
		
		let target = list[indexPath.item]
		cell.colorView.backgroundColor = target.color
		cell.hexLabel.text = target.hex
		cell.nameLabel.text = target.title
		
		return cell
	}
}
















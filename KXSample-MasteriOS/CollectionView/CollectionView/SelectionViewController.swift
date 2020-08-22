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

class SelectionViewController: UIViewController {
	
	lazy var list: [MaterialColorDataSource.Color] = {
		(0...2).map { _ in
			return MaterialColorDataSource.generateSingleSectionData() }.reduce([], +)
	}()
	
	lazy var checkImage: UIImage? = UIImage.init(named: "checked")
	
	@IBOutlet weak var listCollectionView: UICollectionView!
	
	func selectRandomItem() {
		let item = Int(arc4random_uniform(UInt32(list.count)))
		let targetIndexPath = IndexPath(item: item, section: 0)
		
		// 셀을 선택할 때 호출. 인덱스패스 전달하면 선택되고, nil을 전달하면 해지된다.
		listCollectionView.selectItem(at: targetIndexPath, animated: true, scrollPosition: .centeredHorizontally)
		
		
		let color = list[targetIndexPath.item].color
		view.backgroundColor = color
	}
	
	
	// 모든 선택 해지하고, 스크롤 초기화하는 함수 구현해보자.
	func reset() {
		//1 개별 셀을 선택해지 할 때 사용하는 메서드. 이 메서드를 반복해도 전체 해제가 되지만 효율적이지는 않다.
//		listCollectionView.deselectItem(at: <#T##IndexPath#>, animated: <#T##Bool#>)
		
		listCollectionView.selectItem(at: nil, animated: true, scrollPosition: .left)
		
		let firstIndexPath = IndexPath(item: 0, section: 0)
		listCollectionView.scrollToItem(at: firstIndexPath, at: .left, animated: true)
		
		view.backgroundColor = UIColor.white
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showMenu))
		
		// 하나만 선택 가능하게 선택.
		listCollectionView.allowsSelection = true
		listCollectionView.allowsMultipleSelection = false
	}
}


//
extension SelectionViewController: UICollectionViewDelegate {
	
	// 선택 델리게이트
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let color = list[indexPath.item].color
		view.backgroundColor = color
		
		print("#1", indexPath, #function)
		
		
	}
	
	// 선택되기 직전에 호출되는 메서드. 두번 선택 델리게이트 타는 것 방지.
	func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		print("#2", indexPath, #function)
		
		// 선택된 셀이 없으면 트루 리턴.
		guard let list = collectionView.indexPathsForSelectedItems else {
			return true
		}
		
		// 처음엔 선택되어있는 cell이 없겠지. 이미 선택되어있다면, false. 또한 지금 선택하는 indexPath가 아니면 앞에 1번 메서드 호출
		return !list.contains(indexPath)
		
	}
	
	// true면 선택을 해제, false 면 선택상태 유지. 선택 직전에 사용자가 해야할 행동이 있다면, 폴스찍고 경고창 띄우자.
	func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	//
	func collectionView(_ collectionView: UICollectionView, dideselectItemAt indexPath: IndexPath) {
		// cell을 선택하면 이미지 표시되도록

	}
	
	// cell을 강조하기 전에 호출. true면강조, false면 강조안함.
	func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
		print("#3", indexPath, #function)
		return true
	}
	
	// 누르기 시작하면서 바로 누르고있는동안.
	func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
		print("#4", indexPath, #function)
		if let cell = collectionView.cellForItem(at: indexPath) {
			cell.layer.borderWidth = 6
		}
	}
	// 떼는순간 호출
	func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
		if let cell = collectionView.cellForItem(at: indexPath) {
			print("#5", indexPath, #function)
			cell.layer.borderWidth = 0.0
		}
	}
}


extension SelectionViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return list.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
		cell.contentView.backgroundColor = list[indexPath.row].color
		
		return cell
	}
}







extension SelectionViewController {
	@objc func showMenu() {
		let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		
		let randomAction = UIAlertAction(title: "Select Random Item", style: .default) { [weak self] (action) in
			self?.selectRandomItem()
		}
		actionSheet.addAction(randomAction)
		
		let resetPositionAction = UIAlertAction(title: "Reset", style: .default) { [weak self] (action) in
			self?.reset()
		}
		actionSheet.addAction(resetPositionAction)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		actionSheet.addAction(cancelAction)
		
		present(actionSheet, animated: true, completion: nil)
	}
}











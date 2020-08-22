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

class DependencyViewController: UIViewController {
	
	let backgroundQueue = OperationQueue() // 나머지 오퍼레이션.
	let mainQueue = OperationQueue.main // 컬렉션뷰 업데이트하는 오퍼레이션.
	
	// 오퍼레이션 간에 의존성을 다 만든 이후에, 배열에 저장하고 큐에 저장한다.
	var uiOperations = [Operation]()
	var backgroundOperations = [Operation]()
	
	@IBOutlet weak var listCollectionView: UICollectionView!
	
	@IBAction func startOperation(_ sender: Any) {
		// 데이터 목록과 오퍼레이션 목록 초기화 (main Thread)
		PhotoDataSource.shared.reset()
		listCollectionView.reloadData()
		uiOperations.removeAll()
		backgroundOperations.removeAll()
		
		DispatchQueue.global().async {
			let reloadOp = ReloadOperation(collectionView: self.listCollectionView)
			self.uiOperations.append(reloadOp)
			
			for (index, data) in PhotoDataSource.shared.list.enumerated()
			{
				let downloadOp = DownloadOperation(target: data)
				reloadOp.addDependency(downloadOp)
				self.backgroundOperations.append(downloadOp)
				
				let filterOp = FilterOperation(target: data)
				filterOp.addDependency(reloadOp)
				self.backgroundOperations.append(filterOp)
				
				let reloadItemOp = ReloadOperation(collectionView: self.listCollectionView, indexPath: IndexPath(item: index, section: 0))
				
				reloadItemOp.addDependency(filterOp)
				self.uiOperations.append(reloadItemOp)
			}
			
			self.backgroundQueue.addOperations(self.backgroundOperations, waitUntilFinished: false)
			self.mainQueue.addOperations(self.uiOperations, waitUntilFinished: false) // 두번째 파라미터에 트루를 전달하면, 모든 오퍼레이션이 완료될때 까지 완료가 되지 않는다. 메인은 true하면 메인쓰레드가 멈춰서, 블락먹어서 안된다.
		}
		
		
	}
	
	
	@IBAction func cancelOperation(_ sender: Any) {
//		mainQueue.cancelAllOperations()
		
		// mainqueue에서의 캔슬은, 백그라운드처럼, cancelAlloperaions가 안먹고, 개별로 cancel()을 실행하여야 한다.
		uiOperations.forEach {$0.cancel() }
		
		backgroundQueue.cancelAllOperations()
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		PhotoDataSource.shared.reset()
		
		// 백그라운드큐에서 동시에 시행되는 오퍼레이션 수 조절. -> 직접생성하면 다 동시에 시행함. 아래를 1처럼 설정하면, mainqueue처럼 serial하게 작업됨. 5보다 작으면 cpu 부하를 줄이는데 도움이됨.
		backgroundQueue.maxConcurrentOperationCount =  5
	}
}


extension DependencyViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return PhotoDataSource.shared.list.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
		
		let target = PhotoDataSource.shared.list[indexPath.item]
		if let imageView = cell.contentView.viewWithTag(100) as? UIImageView {
			imageView.image = target.data
		}
		
		return cell
	}
}


extension DependencyViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let w = collectionView.bounds.width / 3
		return CGSize(width: w, height: w * (768 / 1024))
	}
}

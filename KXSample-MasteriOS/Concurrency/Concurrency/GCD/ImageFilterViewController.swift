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

class ImageFilterViewController: UIViewController {
	
	@IBOutlet weak var listCollectionView: UICollectionView!
	
	
	// concurrent Queue 생성
	let downloadQueue = DispatchQueue(label: "DownloadQueue", attributes: .concurrent)
	let downloadGroup = DispatchGroup() // 다운로드 그룹
	
	let filterQueue = DispatchQueue(label: "FilterQueue", attributes: .concurrent)
	
	var isCancelled = false
	
	@IBAction func start(_ sender: Any) {
		PhotoDataSource.shared.reset()
		listCollectionView.reloadData()
		
		isCancelled = false
		
		// 1. 배열에있는거 열거하고, 다운로드큐에 추가하자.
		PhotoDataSource.shared.list.forEach { (data) in
			self.downloadQueue.async(group: self.downloadGroup) {
				self.downloadAndResize(target: data)
			}
		}
		
		// 2. 다운로드그룹 완료 후, mainqueue에서 아래 블락의 작업을 하겠다.
		self.downloadGroup.notify(queue: DispatchQueue.main) {
			self.reloadCollectionView()
		}
		
		
		// 3. 필터큐에서는 필터작업을 병렬로 처리하자.
		self.downloadGroup.notify(queue: self.filterQueue) {
			DispatchQueue.concurrentPerform(iterations: PhotoDataSource.shared.list.count) { (index) in
				let data = PhotoDataSource.shared.list[index]
				
				self.applyFilter(target: data)
				
				// 타겟인덱스만 리로드. 현재 필터큐이므로, 메인큐에서 리로드시켜야함.
				let targetIndexPath = IndexPath(item: index, section: 0)
				DispatchQueue.main.async {
					self.reloadCollectionView(at: targetIndexPath)
				}
			}
		}
		
	}
	
	@IBAction func cancel(_ sender: Any) {
		isCancelled = true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		PhotoDataSource.shared.reset()
	}
}


extension ImageFilterViewController {
	
	// 전달된 인덱스페스에따라서 전체 컬렉션뷰를 리로드하거나, 개별셀을 리로드한다.
	func reloadCollectionView(at indexPath: IndexPath? = nil) {
		guard !isCancelled else { print("RELOAD: Cancelled"); return }
		
		print("RELOAD: Start", indexPath ?? "")
		
		defer {
			if isCancelled {
				print("RELOAD: Cancelled", indexPath ?? "")
			} else {
				print("RELOAD: Done", indexPath ?? "")
			}
		}
		
		if let indexPath = indexPath {
			if listCollectionView.indexPathsForVisibleItems.contains(indexPath) {
				listCollectionView.reloadItems(at: [indexPath])
			}
		} else {
			listCollectionView.reloadData()
		}
	}
	
	// 다운로드 & 리사이즈 메서드.
	func downloadAndResize(target: PhotoData) {
		print("DOWNLOAD & RESIZE: Start")
		
		defer {
			if isCancelled {
				print("DOWNLOAD & RESIZE: Cancelled")
			} else {
				print("DOWNLOAD & RESIZE: Done")
			}
		}
		
		guard !Thread.isMainThread else { fatalError() }
		
		guard !isCancelled else { print("DOWNLOAD & RESIZE: Cancelled"); return }
		
		do {
			let data = try Data(contentsOf: target.url)
			
			guard !isCancelled else { print("DOWNLOAD & RESIZE: Cancelled"); return }
			
			if let image = UIImage(data: data) {
				let size = image.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5))
				UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
				let frame = CGRect(origin: CGPoint.zero, size: size)
				image.draw(in: frame)
				let resultImage = UIGraphicsGetImageFromCurrentImageContext()
				UIGraphicsEndImageContext()
				
				guard !isCancelled else { print("DOWNLOAD & RESIZE: Cancelled"); return }
				
				target.data = resultImage
			}
		} catch {
			print(error.localizedDescription)
		}
	}
	
	// 필터 적용 코드.
	func applyFilter(target: PhotoData) {
		print("FILTER: Start")
		
		defer {
			if isCancelled {
				print("FILTER: Cancelled")
			} else {
				print("FILTER: Done")
			}
		}
		
		guard !Thread.isMainThread else { fatalError() }
		guard !isCancelled else { print("FILTER: Cancelled"); return }
		
		guard let source = target.data?.cgImage else { fatalError() }
		let ciImage = CIImage(cgImage: source)
		
		guard !isCancelled else { print("FILTER: Cancelled"); return }
		
		let filter = CIFilter(name: "CIPhotoEffectNoir")
		filter?.setValue(ciImage, forKey: kCIInputImageKey)
		
		guard !isCancelled else { print("FILTER: Cancelled"); return }
		
		guard let ciResult = filter?.value(forKey: kCIOutputImageKey) as? CIImage else { fatalError() }
		
		guard !isCancelled else { print("FILTER: Cancelled"); return }
		
		guard let cgImg = PhotoDataSource.shared.filterContext.createCGImage(ciResult, from: ciResult.extent) else {
			fatalError()
		}
		target.data = UIImage(cgImage: cgImg)
		
		Thread.sleep(forTimeInterval: TimeInterval(arc4random_uniform(3)))
	}
}

extension ImageFilterViewController: UICollectionViewDataSource {
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


extension ImageFilterViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let w = collectionView.bounds.width / 3
		return CGSize(width: w, height: w * (768 / 1024))
	}
}

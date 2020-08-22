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

class PageControlViewController: UIViewController {
   @IBOutlet weak var listCollectionView: UICollectionView!
   
	@IBOutlet weak var pager: UIPageControl!
	
   
   
   let list = [UIColor.red, UIColor.green, UIColor.blue, UIColor.gray, UIColor.black]
   
	//2)
	@IBAction func pageChanged(_ sender: UIPageControl) {
		fromTab = true
		let indexPath = IndexPath(item: sender.currentPage, section: 0)
		listCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
	}
	
	var fromTab = false
	
   override func viewDidLoad() {
      super.viewDidLoad()
      
	pager.numberOfPages = list.count
	pager.currentPage = 0
	
	pager.pageIndicatorTintColor = UIColor.lightGray
	pager.currentPageIndicatorTintColor = UIColor.red
	
	//3) 페이저가 즉시 적용으로 바뀌지 않도록 수정.
	pager.defersCurrentPageDisplay = true

   }
}


//1)
extension PageControlViewController: UIScrollViewDelegate {
	
	// 4) 스크롤이 완료된 후 호출되는 메서드
	func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
		fromTab = false
		pager.updateCurrentPageDisplay()
	}
	
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		guard !fromTab else { return }
		
		let width = scrollView.bounds.size.width
		let x = scrollView.contentOffset.x + (width / 2.0)
		let newPage = Int(x / width)
		if pager.currentPage != newPage {
			pager.currentPage = newPage
		}
	}
}



extension PageControlViewController: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return list.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
      cell.backgroundColor = list[indexPath.item]
      return cell
   }
}


extension PageControlViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return collectionView.bounds.size
   }
}

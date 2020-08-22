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

class SupplementaryViewViewController: UIViewController {
	
	let list = MaterialColorDataSource.generateMultiSectionData()
	
	@IBOutlet weak var listCollectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let layout = listCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			// 스티키 헤더로 만든다.
			layout.sectionHeadersPinToVisibleBounds = true
			
			layout.footerReferenceSize = CGSize(width: 50, height: 50)
		}
		
		listCollectionView.register(FotterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
		
//		// 지정된 위치에있는 supplementary view에 접근할 때 사용한다. indexpath동일하고, kind(푸터,헤더) 동일하면 해당 뷰를 리턴하고, 없으면 nil을 리턴.
//		listCollectionView.supplementaryView(forElementKind: kind, at: IndexPath)
//
//
//		// 컬렉션뷰에 표시되는 서플리먼트리 뷰 중에서, 카인드 일치하는 목록의 인덱스 페스를 리턴.
//		listCollectionView.indexPathsForVisibleSupplementaryElements(ofKind: kind)
//
//		// 카인드 일치하는 서플리먼트리 뷰 중에서, 컬렉션뷰에 표시되어있는 뷰를 리턴.
//		listCollectionView.visibleSupplementaryViews(ofKind: kind)
	}
}

//extension SupplementaryViewViewController: UICollectionViewDelegateFlowLayout {
//	// 헤더의 크기를 리턴할 때 사용하는 메서드
//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//		<#code#>
//	}
//	// 푸터의 크기를 리턴할 때 사용하는 메서드.
//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//		<#code#>
//	}
//}


extension SupplementaryViewViewController: UICollectionViewDataSource {
	
	
	
	// 컬렉션뷰에 서플리먼트리 뷰를 추가하기 위해. cell for item 고 비슷하다. 컬렉션뷰에게 supplymentary view를 요청할 때 사용.
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		print(kind)
		switch kind {
		case UICollectionElementKindSectionHeader:
			// supplementary view를 return하는 메서드. kind, header가진게 존재하면 이 뷰를 리턴하고, 존재하지 않으면 프로토타입에 직접 지정한 걸보고 리턴한다.
			let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderCollectionReusableView
			
			header.sectionTitleLabel.text = list[indexPath.section].title
			
			return header
		case UICollectionElementKindSectionFooter:
			let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath) as! FotterCollectionReusableView
			footer.sectionFooterLabel.text = list[indexPath.section].title
			return footer
		default:
			fatalError("Unsupported kind")
		}
		

	}
	
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










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

class ColorListViewController: UIViewController {
	
	let list = MaterialColorDataSource.generateMultiSectionData()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
}

extension ColorListViewController: UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return list.count
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return list[section].colors.count
	}
	
	// cell을 요청할 때 이 메서드 이용. 첫번째 파라미터에는 재사용 식별자를 전달해야한다.(cell identifier 에 적은 것) 컬렉션뷰는 재사용큐에 파라미터로 전달된 재사용 식별자가 있는지 확인한다. 있다면 바로 리턴하고, 없다면 등록되어있는 프로토타입 셀을 기반으로 새로운 셀을 리턴한다. 셀이 생성될 위치는 indexPath 파라미터로 전달된다. section내에서 cell 위치는 item 속성을 통해 얻을 수 있다(이건 이미 color.swift에서 개발된 부분).
	// cell의 크기는 cell내에서도 커스텀해서 변경 할 수 있지만(디폴트 50,50 아닌거로), 이건 프로토타입에 적용되는 크기이고 실제로 출력되는건 여기서 조절하는게 아니다.
	// cell간에 마진, section간의 마진, cell 크기, 스크롤 방향 같은건 layout을 통하여 구현한다.
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
		
		cell.contentView.backgroundColor = list[indexPath.section].colors[indexPath.row]
		return cell
	}
}



























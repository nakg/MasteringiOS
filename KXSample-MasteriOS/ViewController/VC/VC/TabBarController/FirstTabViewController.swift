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

class FirstTabViewController: UIViewController {
	
	@IBAction func selectSecondTab(_ sender: Any) {
		// child에서 탭바 컨트롤러 접근할 때 :
		// 상수바인딩
		guard let secondChild = tabBarController?.viewControllers?[1] else {return}
		
		tabBarController?.selectedViewController = secondChild
	}
	
	@IBAction func selectThirdTab(_ sender: Any) {
		// 선택할 탭을 인덱스로 지정하는 방법.
		tabBarController?.selectedIndex = 2
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// 탭바 아이템 인스턴스에 새로운 할당. 뷰디드로드 아닌 여기서 해야, 탭바아이템 파란색 되면서 넘어옴.
		
		// 코드로 탭바이미지 설정하기.
		let regularImage = UIImage(named: "calendar_regular")
		let compactImage = UIImage(named: "calendar_compact")
		
		let item = UITabBarItem(title: "Calendar", image: regularImage, selectedImage: compactImage)
		item.badgeColor = UIColor.black
		item.badgeValue = "7"
		
		tabBarItem = item
	
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
}



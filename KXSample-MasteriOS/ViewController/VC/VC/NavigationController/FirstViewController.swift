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

class FirstViewController: UIViewController {
	
	@IBAction func switchChanged(_ sender: UISwitch) {
		switch sender.isOn {
		case true:
			// 왼쪽에 플러스 모양 버튼 만들기.
			navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
			
			// 오른쪽 바버튼 아이템스 가지고 있다가, 새로운 btn 추가하기. 라이트버튼아이템스는 배열의 순서대로 우측부터 채워진다.(역순)
			if var list = navigationItem.rightBarButtonItems {
				let btn = UIBarButtonItem(title: "item", style: .plain, target: nil, action: nil)
				list.append(btn)
				navigationItem.rightBarButtonItems = list
			}
		case false:
			// 왼쪽 다 제거
			navigationItem.leftBarButtonItem = nil
			
			// 스위치 제외한 나머지 제거. 마지막 항목 제거하고 새로운 배열 저장하자.
			let list = navigationItem.rightBarButtonItems?.dropLast()
			navigationItem.rightBarButtonItems = Array(list!)
		}
	}
	
	
	
	// 네비게이션 뒤에 화면에서 스토리보드로 돌아오기 위해, 설정해주어야 하는 메서드. 기본값 사용하고, 이름 바꾸고, 내부 지워도된다.
	@IBAction func unwindToFirst(_ unwindSegue: UIStoryboardSegue) {

	}
	
	@IBAction func pushSecond(_ sender: Any) {
		guard let secnodVC = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") else {return}
		
		// 네비게이션 뷰 컨트롤러 내에, 새로운 차일드를 푸쉬할 때에는 아래 "navigationController"에 접근해야 한다. 모든 뷰 컨트롤러는 navigationController라는 속성을 갖는다. 뷰컨트롤러가 네비게이션컨트롤러에 임배드 되어있다면, navigationController가 리턴되고, 아니면 nil이 리턴된다.
		//원하는 차일드 푸쉬.
		navigationController?.pushViewController(secnodVC, animated: true)
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// 다음화면에서의 back button 결정.
		navigationItem.backBarButtonItem?.title = "Go back"
	}
}


























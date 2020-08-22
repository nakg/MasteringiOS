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

class ContainerViewController: UIViewController {
	
	@IBOutlet weak var bottomContainerView: UIView!
	
	// 컨테이너뷰에서 차일드뷰 전체를 제거하는 로직.
	@objc func removeChild() {
		for vc in childViewControllers {
			vc.willMove(toParentViewController: nil) // 리무브 하기 전에 직접 호출.
			vc.view.removeFromSuperview()
			vc.removeFromParentViewController()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// 차일드뷰는 보통 뷰디드로드에서 생성
		if let childVC = storyboard?.instantiateViewController(withIdentifier: "BottomViewController") {
			addChildViewController(childVC) // 이렇게하면 컨테이너에 차일드로 추가되지만, 실제로 화면에 표시되지는 않는다. 직잡 화면에 표시할 프레임을 설정하고, 뷰계층에 추가해주어야한다.
			childVC.didMove(toParentViewController: self) // 별도의 트랜지션이 있다면, 트랜지션 완료 후에 호출한다. 위 addChildViewController과 세트같은 느낌.
			
			// 차일드의 루트뷰를 계층에 추가하기전에 컨테이너에 추가해야한다. 반대로 제거할때는 뷰계층 제거하고, 컨테이너에서 제거하기.
			childVC.view.frame = bottomContainerView.bounds
			bottomContainerView.addSubview(childVC.view)
		}
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeChild))
	}
}


extension ContainerViewController {
	override var description: String {
		return String(describing: type(of: self))
	}
}





















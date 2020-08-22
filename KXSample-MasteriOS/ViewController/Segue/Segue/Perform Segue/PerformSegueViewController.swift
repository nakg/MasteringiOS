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

class PerformSegueViewController: UIViewController {
	
	@IBOutlet weak var grantedSwitch: UISwitch!
	
	@IBAction func perform(_ sender: Any) {
		// 첫번째 파라미터는 id, 두번쨰파라미터는 세그웨이를 실행시킨 트리거를 전달한다. 트리거에따라서 세그웨이를 제어해야할 떄 사용한다. 필요없다면 nil.
		performSegue(withIdentifier: "manualSegue", sender: self)
	}
	
	// 세그웨이 객체와 데스티네이션 뷰가 생성되고, 세그가 실행되기 직전에 호출. 1: 세그웨이 객체가 전달. 이시점에는 데스티와 소스 둘다 있다. segue.destination, segue.source 둘다 접근 가능. 다만 uiviewcontroller로 업캐스팅되어 리턴이 되어, 실제 뷰컨트롤러로 타입캐스팅이 필요하다.
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? MessageViewController {
			vc.segueName = segue.identifier // segueName은 destination에 선언되어있는 변수.
		}
	}
	
	// 트리거가 세그웨이 실행을 요청하고, 실제 세그웨이 객체가 생성되기 전에 호출. 여기에서 트루리턴하면 세그웨이가 실행되고, 폴스면 바로 종료. 아직 세그웨이 객체 및 destination등이 안정해져 있다.
	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		
		// 컨디셔널 세그는, 스위치 온일떄만 세그웨이 실행되도록 구현.
		if identifier == "conditionalSegue" {
			return grantedSwitch.isOn
		}
		return true
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
	}
}





















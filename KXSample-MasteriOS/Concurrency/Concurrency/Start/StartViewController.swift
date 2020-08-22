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

class StartViewController: UIViewController {
	
	@IBOutlet weak var countLabel: UILabel!
	
	
	@IBAction func start(_ sender: Any) {
		countLabel.text = "0"
		
		logThread(with: "start")
		
		// 내부 블락은 백그라운드에서 작업한다. 실제 시행시점은 시스템에서 현 상황에따라 결정한다.
		DispatchQueue.global().async { // 이 블락은 실행할 코드를 전달하기만 한 후, 바로 리턴된다.
			for count in 0...3 {
				self.logThread(with: "for #\(count)")
				
				// 아래 작업은 메인쓰레드에서 작업한다. 백그라운드에서 코드를 작업한 다음, 유아이를 업데이트를 할 때 많이 사용하는 구조이다.
				DispatchQueue.main.async {
					self.logThread(with: "update label")
					self.countLabel.text = "\(count)"
				}
				Thread.sleep(forTimeInterval: 0.1) // 파라미터로 전달한 시간동안 쓰레드의 시행을 일시 중지한다. 매 반복마다 0.1초의 지연시간이 추가된다.
			}
			self.logThread(with: "Done")
		}
		self.logThread(with: "End")
	}
	
	func logThread(with task: String) {
		if Thread.isMainThread {
			print("Main Thread: \(task)")
		} else {
			print("Background Thread: \(task)")
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
}

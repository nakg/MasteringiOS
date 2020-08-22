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

class DispatchGroupViewController: UIViewController {
	
	// ConcurrentQueue 및 Serial Queue가 선언되어있다.
	let workQueue = DispatchQueue(label: "WorkQueue", attributes: .concurrent)
	let serialWorkQueue = DispatchQueue(label: "SerialWorkQueue")
	
	// 하단의 모든작업을 그룹으로 묶고, 모든 작업이 끝난 다음 로그를 출력해보자.
	let group = DispatchGroup()
	
	
	@IBAction func submit(_ sender: Any) {
		// async메서드에는 그룹파라미터를 같이 넣으면서 작업할 수 있다.
		workQueue.async(group: group) {
			for _ in 0..<10 {
				print("🍏", separator: "", terminator: "")
				Thread.sleep(forTimeInterval: 0.1)
			}
		}
		
		workQueue.async {
			for _ in 0..<10 {
				print("🍎", separator: "", terminator: "")
				Thread.sleep(forTimeInterval: 0.2)
			}
		}
		
		serialWorkQueue.async(group: group) {
			for _ in 0..<10 {
				print("🍋", separator: "", terminator: "")
				Thread.sleep(forTimeInterval: 0.3)
			}
		}
		
		// Dispatchgroup 클래스는, workItem과 마찬가지로, notify와 wait메서드를 제공한다. 구현패턴도 동일하다.
		// notify -> 그룹이 완료된 다음 안에 블락 실행.
		group.notify(queue: DispatchQueue.main) {
			print("Done")
		}
	}
}


















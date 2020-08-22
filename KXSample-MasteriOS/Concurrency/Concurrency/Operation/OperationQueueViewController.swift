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

class OperationQueueViewController: UIViewController {
	
	let queue = OperationQueue() // 백그라운드 생성
	
	var isCancelled = false
	
	let queue2 = OperationQueue.main // 메인에 생성. UI 업데이트 등.
	
	@IBAction func startOperation(_ sender: Any) {
		
		isCancelled = false
		
		// Block을 Queue에 직접 오퍼레이션 생성하면서 넣는 방식.
		queue.addOperation {
			autoreleasepool { // operation은 메모리 관리 직접 안해줘서, 직접 autoreleasepool을 해줘야한다.
				for _ in 1..<100 {
					guard !self.isCancelled else { return }
					print("♥️", separator: " ", terminator: " ")
					Thread.sleep(forTimeInterval: 0.3)
				}
			}
		}
		
		// 오퍼레이션 개별 생성
		let op = BlockOperation {
			autoreleasepool {
				for _ in 1..<100 {
					guard !self.isCancelled else { return }
					print("🔈", separator: " ", terminator: " ")
					Thread.sleep(forTimeInterval: 0.6)
				}
			}
		}
		queue.addOperation(op) // 생성한 오퍼레이션을 큐에 삽입.
		
		// Block Operation은 블락을 추가할 수 있다는 장점이 있다. 실행중이거나, 실행시작안했으면 추가 되지만, 완료됐을 경우 예외 발생할 수 있음을 주의하자.
		op.addExecutionBlock {
			autoreleasepool {
				for _ in 1..<100 {
					guard !self.isCancelled else { return }
					print("🔔", separator: " ", terminator: " ")
					Thread.sleep(forTimeInterval: 0.5)
				}
			}
		}
		
		let op2 = CustomOperation(type: "♠️")
		queue.addOperation(op2)
		
		// operation에 구현되어있는 코드 완료된 후에출력.
		op.completionBlock = {
			print("Done")
		}
		
	}
	
	@IBAction func cancelOperation(_ sender: Any) {
		isCancelled = true
		queue.cancelAllOperations() // 큐 내에 오퍼레이션을 전부 제거한다는 의미. 단, 실제 멈추는게 아니라, isTrue 속성을 false로 바꾸는 정도. 실제로 이걸 읽어서 취소시키는 코드 구현이 추가로 필요하다.
	}
	
	deinit {
		print(self, #function)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		isCancelled = true
		queue.cancelAllOperations()
	}
}

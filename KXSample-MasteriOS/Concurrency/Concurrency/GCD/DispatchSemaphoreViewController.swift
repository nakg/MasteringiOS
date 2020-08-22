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

class DispatchSemaphoreViewController: UIViewController {
	
	var value = 0
	
	@IBOutlet weak var valueLabel: UILabel!
	
	let workQueue = DispatchQueue(label: "WorkQueue", attributes: .concurrent)
	let group = DispatchGroup()
	
	// workQueue의 모든 작업은 동일한 그룹으로 실행된다. -> 3개를 세마포어 없이 그냥 그룹으로 시행하면 3000이 안나옴 :이것은 모든 큐가 value에 동시에 접근하는게 원인. 첫번째 작업에서 0을 1로 증가시키면, 나머지 작업은 증가된 값이 아니라 동일한 시간에 접근하면 둘다 2로 증가시키고 저장한다. -> Dispatchqueue를 Serial로 바꾸거나, semapohre를 활용해야한다.
	@IBAction func synchronize(_ sender: Any) {
		value = 0
		valueLabel.text = "\(value)"
		
		// 세마포어 생성
		let sem = DispatchSemaphore(value: 1) // 보통 리소스풀 관리할때는 0보다 큰값을 초기값으로 지정한다. 지금처럼 여러작업 순서대로 실행하려면 1을 넣어야 한다. 세마포어 구현패턴은 요청과 대기의 반복이다. 먼저, 작업을 시행하기전에 세마포어에 요청해야한다. 관리하고있는 카운트가 0보다 큰지 확인한다. 0보다 크면 이값을 1 감소시키고 실행을 허가한다. 반면, 카운티가 0이라면 카운트가 증가할때까지 대기한다. -> 이역할을 수행하는것이 wait 메서드. value를 증가시키는 앞에서 호출해야한다.
		
		workQueue.async(group: group) {
			for _ in 1...1000 {
				sem.wait() // 일단 기다려. 카운트 체크해.
				self.value += 1
				sem.signal() // 작업이완료되었으니, 대기중인 다른작업을 실행할 수 있게 만들어.
				
				// 위 웨이트와 시그널로 인하여, value의 증가하는 부분은, 동시에 실행되지 않고 하나씩 실행된다.
			}
		}
		
		workQueue.async(group: group) {
			for _ in 1...1000 {
				sem.wait()
				self.value += 1
				sem.signal()
			}
		}
		
		workQueue.async(group: group) {
			for _ in 1...1000 {
				sem.wait()
				self.value += 1
				sem.signal()
			}
		}
		
		// 그룹 완료 후, 총합 출력.
		group.notify(queue: DispatchQueue.main) {
			self.valueLabel.text = "\(self.value)"
		}
	}
	
	@IBAction func controlExecutionOrder(_ sender: Any) {
		value = 0
		valueLabel.text = "\(value)"
		
		// 아래 두 코드는 서로다른 디스팻치큐에서 실행되므로, 순서대로 실행되지 않는다. -> semaphore 생성하자.
		
		// 세마포어 생성
		let sem = DispatchSemaphore(value: 0)
		
		workQueue.async {
			for _ in 1...100 {
				self.value += 1
				Thread.sleep(forTimeInterval: 0.1)
			}
			
			sem.signal() // 카운트는 증가하지 않지만, 웨이트를 호출하고 대기중인 코드에게 실행이 완료됨을 알려줌.
		}
		
		DispatchQueue.main.async {
			sem.wait() // 메인큐에서 wait메서드 호출하면, 또 UI블락 된다. 데드락. 순서 제어되는거만 보기위한 예제. 실제론 절대 wait를 메인큐에서 호출하면 안된다.
			self.valueLabel.text = "\(self.value)"
		}
	}
}

















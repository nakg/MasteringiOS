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

class DispatchWorkItemViewController: UIViewController {
	
	let workQueue = DispatchQueue(label: "WorkQueue") // serial dispatch queue
	var currentWorkItem: DispatchWorkItem!
	
	// item 생성하고 currentWorkItem에 저장.
	@IBAction func submitItem(_ sender: Any) {
		currentWorkItem = DispatchWorkItem(block: {
			guard !self.currentWorkItem.isCancelled else { return } // 취소필요할 때 구현. 캔슬부는 따로둬야한다.
			for num in 0..<100 {
				print(num, separator: " ", terminator: " ")
				Thread.sleep(forTimeInterval: 0.1)
			}
		})
		
		// dispatch item을 dispatch에 추가할 때에는, async나 sync의 두가지로 추가 가능.
		
		workQueue.async(execute: currentWorkItem)
		
		// 워크아이템 실행이 완료된 이후 호출. notify로 추가한 코드는 dispatchworkItem에서 데드락이 발생되면 실행되지 않는다. -> wait메서드는 이런문제를 해결할 때 사용됨.
		currentWorkItem.notify(queue: workQueue) {
			print("done")
		}
		
		//
//		currentWorkItem.wait()  -> 완료될 떄 까지 대기.
		let result = currentWorkItem.wait(timeout: .now() + 3) // 언제까지 대기할지 정하는 메서드. 타임아웃에의한 건지, 최대시간 도달전 정상적으로 도달한건지 리턴한다. -> 아래 코드 시행하면 3초간 버튼이 비활성화 되고(wait메서드가 메인쓰레드를 블로킹함. -> notify와달리 wait메서드는 동기 메서드이다. 그래서 메인쓰레드에서 호출되지 않도록 주의해야한다.), 3초지나면 timeout 출력됨. wait걸렸어도 남은 코드들은 시행은 함.
		switch result {
		case .timedOut:
			print("timeOut")
		case .success:
			print("success")
		}
	}
	
	// DispatchQueue는 취소 API를 제공하지 않는다. 그래서 Dispatch Work Item에대한 참조를 저장해두었다가 캔슬메서드를 개별적으로 호출해야한다. 캔슬여부는 iscanceld를 통해 확인. 그런데 생성자를 전달하는 블록에서는 이 속성에 접근할 수 없다.(이전 방식) 따라서 currentWorkItem속성을 통하여 접근해야한다.
	@IBAction func cancelItem(_ sender: Any) {
		currentWorkItem.cancel() // operation보다는 워크아이템의 취소가 좋지 않다. 특히, 작업이 늘어날수록 안좋다. 취소기능 필요하다면 operation을 추천한다.
	}
}

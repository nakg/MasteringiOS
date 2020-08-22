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


class DispatchQueueViewController: UIViewController {
	
	@IBOutlet weak var valueLabel: UILabel!
	
	let serialWorkQueue = DispatchQueue(label: "SerialWorkQueue") // label은 dispatchqueue를 구분할 때 쓰는 값. 별도의 셋팅 안하면 serial queue가 생성된다.
	
	let concurrentWorkQueue = DispatchQueue(label: "ConcurrentWorkQueue", attributes: .concurrent) // 자동완성때 뜨는 나머지 속성들은 의미가 없다. 이렇게 작업을 동시에 시행하는 큐를 만들어주자.

	// 액션메서드는 메인쓰레드에서 시행된다. 아래 10초의 시간동안 메인쓰레드가 블로킹되고, 다른 유아이적인 부분을 처리하지 못한다. 매우빠르게 시행되는 코드와 유아이 업데이트 코드를 제외한 나머지 코드는 반드시 백그라운드에서 시행해야 한다. -> 이로인해 두가지의 디스팻치큐를 추가함. 결국은 기본코드를 제외하고, 만약 유아이에 영향을 주는 코드들이 있다면, 이 영향을 주는 부분에대한 부분은 글로벌에서 담당하고, 유아이 변경부분만 메인에 넣으면 되겠다.  -> 목적 : 메인쓰레드에 블락을 일으키지 않으면서, 백그라운드의 긴 시간 걸리는 코드를 쉽게 작업할 수 있다.
	@IBAction func basicPattern(_ sender: Any) {
		DispatchQueue.global().async { // global() 는 백그라운드 큐를 리턴한다.
			var total = 0
			for num in 1...100 {
				total += num
				Thread.sleep(forTimeInterval: 0.1)
			}
			DispatchQueue.main.async { // main은 메인큐를 리턴한다.
				self.valueLabel.text = "\(total)" // 유아이 변경부
			}
		}
	}
	
	
	// DispatchQueue가 제공하는 sync, async의 메서드는, 실행할 작업을 DispatchQueue에 추가하는 메서드. 실행하는 메서드가 아니다. 작업을 실제로 시행하는것은 Dispatch Queue 이다.
	
	// sync는 파라미터에 전달된 작업을 동기방식으로 추가한다. 바꿔말하면 작업을 추가한다음 바로 리턴하지 않고, 작업이 완료될 때까지 대기한다. 작업이 완료되면 이어지는 코드를 시행한다. -> 그래서 포인트1 이후 포인트2 출력. 이는 주로 rock과 유사한 기능을 구현할때사용. 메인큐에서 sync메서드를 호출하면 크래쉬발생.
	@IBAction func sync(_ sender: Any) {
		concurrentWorkQueue.sync {
			for _ in 0..<3 {
				print("Hello")
			}
			print("Point 1")
		}
		print("Point2")
	}
	
	// 작업을 비동기방식으로 추가한다. 포인트2가 제일 먼저 출력. 작업만 추가한다음 우선 디스팻치를 바로 리턴한다. 그래서 이어진 코드가 먼저 바로 시행된다. 어떤 큐에서 호출하더라도, 연관된 쓰레드를 블로킹하지 않기 떄문에 대부분 async로 작업한다.
	// 추가로 sync, async 메서드는 dispatchqueue 동작방식에는 영향을 주지 않는다. 씨리얼큐에 작업을 추가할 때에는 어떤메서드든, 추가된순서대로 시행된다. concurrentqueue에 추가할때 sync를 사용하면, 작업이 추가된 순서대로 하나씩 시행되는것 처럼 보이지만, 큐가 작업을 동시에 수행할 수 있다는 것은 달라지지 않는다. 다른곳에서 작업을 큐에 추가하면 현재실행중인 작업과 동시에 실행된다.
	@IBAction func async(_ sender: Any) {
		concurrentWorkQueue.async {
			for _ in 0..<3 {
				print("Hello")
			}
			print("Point 1")
		}
		
		print("Point2")
	}
	
	// 실행시간 지연시키기.
	@IBAction func delay(_ sender: Any) {
		// 디스패치 프레임워크에서 사용되는 시간은, 디스패치 타임 구조체로 생성한다.
		let delay = DispatchTime.now() + 3 // 구조체에 now는 현재시간을 리턴한다.
		
		// 아래는 async이므로 "Point2"가 먼저 출력. 그리고 3초뒤에 예약된 블락코드가 시행되고, "Point1"출력.
		concurrentWorkQueue.asyncAfter(deadline: delay) {
			print("Point 1")
		}
		
		print("Point 2")
	}
	
	// 반복코드 빠르게 처리하기.
	@IBAction func concurrentIteration(_ sender: Any) {
		
		// 동기적으로 반복문 처리하는 일반 코드는, 0.1 * 20 해서 2초정도 걸림.
		var start = DispatchTime.now()
		for index in 0..<20 {
			print(index, separator: " ", terminator: " ")
			Thread.sleep(forTimeInterval: 0.1)
		}
		var end = DispatchTime.now()
		print("\nfor-in ",Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1000000000)
		
		// 비동기 반복문 코드. dispatchQueue에 비동기 반복 시행문. 1~20이 순서대로 나오진 않지만 1/10 정도 시간 걸림. 순서 상관없을 때 좋은 코드. 쓰레드가 순서는 알아서 정한다.
		start = .now()
		DispatchQueue.concurrentPerform(iterations: 20) { (index) in
			print(index, separator: " ", terminator: " ")
			Thread.sleep(forTimeInterval: 0.1)
		}
		end = .now()
		print("\nconcurrentPerform ",Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1000000000)
	}
}

























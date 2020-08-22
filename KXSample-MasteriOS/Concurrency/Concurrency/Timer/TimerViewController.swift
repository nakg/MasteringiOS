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

class TimerViewController: UIViewController {
	
	@IBOutlet weak var timeLabel: UILabel!
	
	lazy var formatter: DateFormatter = {
		let f = DateFormatter()
		f.dateFormat = "hh:mm:ss"
		return f
	}()
	
	@IBAction func unwindToTimerHome(_ sender: UIStoryboardSegue) {
		
	}
	
	// 타이머 시간 라벨 업데이트
	func updateTimer(_ timer: Timer) {
		print(#function, Date(), timer)
		timeLabel.text = formatter.string(from: Date())
	}
	
	func resetTimer() {
		timeLabel.text = "00:00:00"
	}
	
	// 타이머클래스 생성.
	var timer: Timer?
	
	//
	@objc func timerFired(_ timer: Timer) {
		updateTimer(timer)
	}
	
	@IBAction func startTimer(_ sender: Any) {
		// 이미 타이머 돌고 있다면 리턴.
		guard timer == nil else { return }
		
		// 1. 타임메서드로 생성한 코드
		// 타이머 생성. 주기 1초, 반복여부 true, 블락으로 코드시행.
		// scheduled접두어 -> 타임메서드로 타이머를 생성하면 런루프에 자동으로 추가되고 바로 생성된다.
//		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
//			guard timer.isValid else { return } // 속성이 유효할 때에만 시행.
//			self.updateTimer(timer)
//		})
		
		// 2. 생성자를 통하여 타이머를 만들어보자.
		timer = Timer(timeInterval: 1, target: self, selector: #selector(timerFired(_:)), userInfo: nil, repeats: true)
		timer?.tolerance = 0.2 // 타이머는 오차가 있다. 이 오차 범위.
		// 생성자를 통하여 추가하면, 런루프에 자동으로 추가되지는 않는다. 현재의 런루프에 타이머를 추가해주어야 한다
		RunLoop.current.add(timer!, forMode: .defaultRunLoopMode)
		timer?.fire()
	}
	
	@IBAction func stopTimer(_ sender: Any) {
		timer?.invalidate() // 타이머 중지. 타이머가 런루프에서 제거. -> 제거된 타이머는 재사용 불가. 다시 쓰려면 다시 타이머를 생성해야 한다. 그리고 타이머를 생성한 쓰레드와 동일한 쓰레드에서 메서드를 호출해야한다. 안그러면 타이머가 정상중지 되지 않을 수 있다.
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		resetTimer()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		startTimer(self)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		timer?.invalidate()
		timer = nil
	}
}

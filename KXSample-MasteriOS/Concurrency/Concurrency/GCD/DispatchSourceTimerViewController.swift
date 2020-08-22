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

class DispatchSourceTimerViewController: UIViewController {
	
	@IBOutlet weak var timeLabel: UILabel!
	
	lazy var formatter: DateFormatter = {
		let f = DateFormatter()
		f.dateFormat = "hh:mm:ss"
		return f
	}()
	
	// 타이머 저장
	var timer: DispatchSourceTimer?
	
	@IBAction func start(_ sender: Any) {
		// 타이머가 없을때만 시행.
		if timer == nil {
			timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)// 레이블에 텍스트 바꾸는 디스팻치 실행해야하므로 메인큐를 넣어주자.
			timer?.schedule(deadline: .now(), repeating: 1) // 바로, 1초마다.
			// 타이머 이벤트 핸들러 구현.
			timer?.setEventHandler(handler: {
				self.timeLabel.text = self.formatter.string(from: Date())
				print(self.timeLabel.text ?? "")
			})
			
			// Dispatch Source Timer는 자동으로 시작되지는 않는다. 스케쥴을 지정하고 이벤트핸들러를 구현한다음, resume을 호출해야한다.
		}
		// 타이머 시행하면서 실행시키기 or 서스팬드 하다가 다시 스타트 누를때도 실행시키기.
		timer?.resume()
	}
	
	@IBAction func suspend(_ sender: Any) {
		timer?.suspend() // timer를 일시정지 할 때에는, 서스펜더를 호출한다.
	}
	
	@IBAction func stop(_ sender: Any) {
		timer?.cancel() // timer를 완전히 중지시킬 때는, 캔슬메서드를 사용한다. 보통 캔슬 후 nil을 저장해서 메모리에서 제거한다.
		timer = nil
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		timer?.resume() // 진입할 때 다시 타이머 시작.
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		stop(self)
	}
}

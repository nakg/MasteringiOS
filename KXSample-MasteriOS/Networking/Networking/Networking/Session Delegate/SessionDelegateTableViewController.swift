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

class SessionDelegateTableViewController: UITableViewController {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descLabel: UILabel!
	
	var session: URLSession!
	
	// Code Input Point #3
	var buffer: Data? // 세션델리게이트로 하면, 데이터가 그때그때와서 한번에 통을 볼수 없다. 버퍼를 통해 누적시키자.
	// Code Input Point #3
	
	@IBAction func sendReqeust(_ sender: Any) {
		guard let url = URL(string: "https://kxcoding-study.azurewebsites.net/api/books/3") else {
			fatalError("Invalid URL")
		}
		
		// Code Input Point #1
		let configuration = URLSessionConfiguration.default
	// 해당 세션은 3개의 파라미터를 받으면서 생성된다. 1: configuration, 2:self, 3: 메인큐를 전달하여, 모든 델리게이트 메서드가 mainqueue에서 실행되도록 한다.
		session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
		
		// 테스크 시작전 인스턴스 생성.
		buffer = Data()
		
		let task = session.dataTask(with: url)
		task.resume()
		// Code Input Point #1
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// Code Input Point #6
		// 지금처럼 url세션을 직접생성하고 델리게이트를 설정하면 두 객체가 강한참조로 연결된다. -> 세션을 사용한다음 리소스를 정리해야 메모리에 효율
//		session.finishTasksAndInvalidate() // 현재 실행중인 모든 테스트가 정리될 때 까지 기다렸다가 리소스를 정리한다. 이거하면 새로 세션 생성하고 다시 해야한다.
		session.invalidateAndCancel() // 바로 리소스 정리하고 실행중인 모든 테스크를 중지한다. 이거하면 새로 세션 생성하고 다시 해야한다.
		// Code Input Point #6
	}
}

// Code Input Point #2
extension SessionDelegateTableViewController: URLSessionDataDelegate {
	// 서버로부터 최초로 응답을 받았을 때 호출, 응답정보는 3번째 파라미터로 전달.
	func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
		guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
			completionHandler(.cancel) // 성공 코드가 아닌 경우 캔슬을 전달.
			return
		}
		
		completionHandler(.allow) // 이걸 하면, 서버로부터 데이터 전송이 시작된다.
	}
	
	// 서버에서 데이터가 전달될 때 마다 반복적으로 호출된다. 마지막 파라미터에는 새롭게 전달된 뉴 데이터가 전달된다.
	func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		buffer?.append(data) // 전달된 데이터 누적.
	}
	
	// 데이터 전송이 완료된 다음 호출된다.
	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		// 오류 없다면 nil이 전달된다. 이로 성공여부를 판단한다.
		if let error = error {
			showErrorAlert(with: error.localizedDescription)
		}
		else {
			parse() // 정상적으로 완료된 경우
		}
	}
	
}
// Code Input Point #2

extension SessionDelegateTableViewController {
	func parse() {
		// Code Input Point #4
		// 시작부분에 버퍼속성에 저장된 속성을 바인딩하는 부분을 추가하자.
		guard let data = buffer else {
			fatalError("Invalid Buffeer")
		}
		
		// Code Input Point #4
		
		let decoder = JSONDecoder()
		
		decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
			let container = try decoder.singleValueContainer()
			let dateStr = try container.decode(String.self)
			
			let formatter = ISO8601DateFormatter()
			formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
			return formatter.date(from: dateStr)!
		})
		
		// Code Input Point #5
		do {
			let detail = try decoder.decode(BookDetail.self, from: data)
			
			if detail.code == 200 {
				titleLabel.text = detail.book.title
				descLabel.text = detail.book.desc
				tableView.reloadData()
			}
			else {
				showErrorAlert(with: detail.message ?? "")
			}
			
		} catch {
			showErrorAlert(with: error.localizedDescription)
			print(error)
		}
		// Code Input Point #5
	}
}

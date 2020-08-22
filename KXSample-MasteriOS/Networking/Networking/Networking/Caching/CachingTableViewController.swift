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


class CachingTableViewController: UITableViewController {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descLabel: UILabel!
	@IBOutlet weak var lastUpdateDateLabel: UILabel!
	
	var buffer: Data?
	
	var lastDate = Date()
	
	lazy var formatter: ByteCountFormatter = {
		let f = ByteCountFormatter()
		f.countStyle = .file
		return f
	}()
	
	lazy var dateFormatter: DateFormatter = {
		let f = DateFormatter()
		f.dateFormat = "HH:mm:ss.SSS"
		return f
	}()
	
	lazy var session: URLSession = { [weak self] in
		let config = URLSessionConfiguration.default
		
		// Code Input Point #3
		// request레벨이 아닌, session 레벨에서 캐싱 정책을 구현해보자. 여기에서 설정한 정책은, 세션을 통해 생성된 모든 테스크에 공통적으로 적용된다.
		config.requestCachePolicy = .reloadIgnoringLocalCacheData // 로칼 캐시 무시.
		// Code Input Point #3
		
		let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
		return session
		}()
	
	@IBAction func sendRequestCacheControl(_ sender: Any) {
		guard let url = URL(string: "https://kxcoding-study.azurewebsites.net/api/cache") else {
			fatalError("Invalid URL")
		}
		
		print(#function)
		
		buffer = Data()
		
		var request = URLRequest(url: url)
		
		// Code Input Point #1
//		request.cachePolicy = .returnCacheDataElseLoad // 캐시가 저장되어있지 않은 경우에만, 새로운요청을 한다.
		request.cachePolicy = .useProtocolCachePolicy // 이렇게하면 해당 요청에 대해, 세션정책을 무시하고 캐시컨트롤에 지정된 시간만큼 캐시를 유지한다.
		// Code Input Point #1
		
		let task = session.dataTask(with: request)
		task.resume()
	}
	
	@IBAction func sendReqeust(_ sender: Any) {
		guard let url = URL(string: "https://kxcoding-study.azurewebsites.net/api/cache/nocache") else {
			fatalError("Invalid URL")
		}
		
		print(#function)
		
		buffer = Data()
		
		var request = URLRequest(url: url)
		request.cachePolicy = .returnCacheDataElseLoad
		
		// Code Input Point #2
		if lastDate.timeIntervalSinceNow < -5 {
			request.cachePolicy = .reloadIgnoringLocalCacheData // 5초 안지났으면, 새로운 정보 안받음. 기존 로칼캐시 사용
			lastDate = Date()
		}
		else {
			request.cachePolicy = .returnCacheDataElseLoad // 5초 안지났으면 로칼캐시 사용.
		}
		// Code Input Point #2
		
		let task = session.dataTask(with: request)
		task.resume()
	}
	
	@IBAction func removeAllCache(_ sender: Any) {
		// Code Input Point #5
		// 정책이 바뀌었다면 캐시를 다 날리는게 좋다. 만료전까지 사용되므로.
		session.configuration.urlCache?.removeAllCachedResponses()
		// Code Input Point #5
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		session.invalidateAndCancel()
	}
}

extension CachingTableViewController: URLSessionDataDelegate {
	// Code Input Point #4
	// 서버에서 보낸 응답 데이터를 캐시에 저장하기 직전에 호출. 캐시에는 바이너리 데이터만 저장되지 않는다. 서버응답과 관련된 메타데이터도 함께 저장된다. 형식은 CachedURLResponse. 아래메서드 구현 안했다면, 기본적으로 메모리캐시와 디스크캐시 모두에 저장하는게 디폴트이다.
	func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
		guard let url = proposedResponse.response.url else {
			completionHandler(nil)
			return
		}
		
		// 우리가 아는넘은, 메모리, 디스크에 모두 캐시저장. 디폴트를 바로 넣는다.(디폴트가 둘다 넣는거니까)
		if url.host == "kxcoding-study.azurewebsites.net" {
			completionHandler(proposedResponse)
		}
			// https는 따로 만들어서 넣는다.
		else if url.scheme == "https" {
			let response = CachedURLResponse(response: proposedResponse.response, data: proposedResponse.data, userInfo: proposedResponse.userInfo, storagePolicy: .allowedInMemoryOnly)
			completionHandler(response)
		}
			// 나머지 무시한다.
		else {
			let response = CachedURLResponse(response: proposedResponse.response, data: proposedResponse.data, userInfo: proposedResponse.userInfo, storagePolicy: .notAllowed)
			completionHandler(response)
		}
	}
	// Code Input Point #4
	
	func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
		guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
			completionHandler(.cancel)
			return
		}
		
		completionHandler(.allow)
	}
	
	func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		buffer?.append(data)
	}
	
	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		if let error = error {
			showErrorAlert(with: error.localizedDescription)
		} else {
			parse()
		}
	}
}

extension CachingTableViewController {
	func parse() {
		guard let data = buffer else {
			fatalError("Invalid Buffer")
		}
		
		let decoder = JSONDecoder()
		
		decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
			let container = try decoder.singleValueContainer()
			let dateStr = try container.decode(String.self)
			
			let formatter = ISO8601DateFormatter()
			formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
			return formatter.date(from: dateStr)!
		})
		
		do {
			let detail = try decoder.decode(BookDetail.self, from: data)
			
			if detail.code == 200 {
				titleLabel.text = detail.book.title
				descLabel.text = detail.book.desc
				
				let date = dateFormatter.string(from: Date())
				lastUpdateDateLabel.text = "Last Update\n\(date)"
				tableView.reloadData()
			} else {
				showErrorAlert(with: detail.message ?? "Error")
			}
		} catch {
			showErrorAlert(with: error.localizedDescription)
			print(error)
		}
	}
}


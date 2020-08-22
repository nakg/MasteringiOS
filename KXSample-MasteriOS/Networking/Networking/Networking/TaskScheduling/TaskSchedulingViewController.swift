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

class TaskSchedulingViewController: UIViewController {
	@IBOutlet weak var sizeLabel: UILabel!
	
	lazy var formatter: ByteCountFormatter = {
		let f = ByteCountFormatter()
		f.countStyle = .file
		return f
	}()
	
	var task: URLSessionDownloadTask?
	
	lazy var session: URLSession = { [weak self] in
		let config = URLSessionConfiguration.background(withIdentifier: "SampleSession")
		
		// Code Input Point #2
		config.isDiscretionary = true // true면 ios에게 테스크 실행시작점에대한 재량권을 부여한다. 특히, 큰 데이터 사용할 때 유용. 셀룰러 연결되어있다면 와이파이 연결까지 다운로드를 연기할 수 있다. 당장필요한거 아니라면 이게 좋다.
		// Code Input Point #2
		
		let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
		return session
		}()
	
	@IBAction func startDownload(_ sender: Any) {
		guard let url = URL(string: bigFileUrlStr) else {
			fatalError("Invalid URL")
		}
		
		task = session.downloadTask(with: url)
		
		// Code Input Point #1
		// 위 테스크가 5초뒤에 실행되도록 해보자.
		task?.earliestBeginDate = Date(timeIntervalSinceNow: 5) // 네트워크 지연이 있더라도 최소 5초뒤에 실행.
		task?.countOfBytesClientExpectsToSend = 80 // 클라이언트에서 서버로 전달하는 요청의 크기.
		task?.countOfBytesClientExpectsToReceive = 1024 * 1024 * 40 // 서버에서 다운로드되는 크기. 강제사항은 아니다. 최적화의 힌트. 이 두개를 참고해서 최적의 실행시간을 판단함.
		
		sizeLabel.text = "Delayed..."
		// Code Input Point #1
		
		task?.resume()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		session.invalidateAndCancel()
	}
}


extension TaskSchedulingViewController: URLSessionDownloadDelegate {
	// Code Input Point #3
	
	// 지연된 테스크가 실행되기 직전에 실행. 보통 유아이 구현보다는 테스크 처리방법을 구현하기 위해 사용한다. 3: 리퀘스트 통해서 요청정보를 파악한다음 최종 방식을 파악한다. ex) 다음달 메거진의 다운로드 url이 바뀌었다면 새로운 url을 제공하고, 결재를 취소했다면 다운로드도 취소해야한다.
	func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) {
		DispatchQueue.main.async {
			self.sizeLabel.text = "Go!"
		}
		completionHandler(.continueLoading, nil) // 이전꺼 그대로 실행.
	}
	// Code Input Point #3
	
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
		sizeLabel.text = "\(formatter.string(fromByteCount: totalBytesWritten))/\(formatter.string(fromByteCount: totalBytesExpectedToWrite))"
	}
	
	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		print(#function)
		print(error ?? "Done")
	}
	
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		print(#function)
	}
}

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

class AdaptableConnectivityViewController: UIViewController {
	
	@IBOutlet weak var sizeLabel: UILabel!
	
	lazy var formatter: ByteCountFormatter = {
		let f = ByteCountFormatter()
		f.countStyle = .file
		return f
	}()
	
	lazy var session: URLSession = { [weak self] in
		let config = URLSessionConfiguration.default
		
		// Code Input Point #1
		config.waitsForConnectivity = true // 어뎁티블 컨넥티비티 활성화. 네트워크에 연결될 때 까지 지금안되도 대기. 네트워크 연결을 대기하고 있다면 사용자는 이 사실을 인지하기 어렵다. 시각적 피드백이 필요하다.
		
		config.timeoutIntervalForResource = 5 // 타임아웃.
		// Code Input Point #1
		
		let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
		return session
		}()
	
	var task: URLSessionDownloadTask?
	
	@IBAction func startDownload(_ sender: Any) {
		guard let url = URL(string: smallFileUrlStr) else {
			fatalError("Invalid URL")
		}
		
		task = session.downloadTask(with: url)
		task?.resume()
	}
	
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		session.invalidateAndCancel()
	}
}

extension AdaptableConnectivityViewController: URLSessionDownloadDelegate {
	// Code Input Point #2
	// 네트워크 통신 시, 사용가능한 네트워크가 없을 때 호출. 대기 없이 바로연결할땐 호출 안한다.
	func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
		print(#function)
		sizeLabel.text = "Waiting.."
	}
	// Code Input Point #2
	
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
		sizeLabel.text = "\(formatter.string(fromByteCount: totalBytesWritten))/\(formatter.string(fromByteCount: totalBytesExpectedToWrite))"
	}
	
	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		print(#function)
		// -1001, NSURLErrorTimedOut
		
		if let error = error {
			print(error)
			showErrorAlert(with: error.localizedDescription)
		}
	}
	
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		print(#function)
	}
}

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

class BackgroundDownloadViewController: UIViewController {
	
	@IBOutlet weak var sizeLabel: UILabel!
	@IBOutlet weak var recentDownloadLabel: UILabel!
	
	lazy var sizeFormatter: ByteCountFormatter = {
		let f = ByteCountFormatter()
		f.countStyle = .file
		return f
	}()
	
	lazy var dateFormatter: DateFormatter = {
		let f = DateFormatter()
		f.dateFormat = "MM/dd HH:mm:ss.SSS"
		return f
	}()
	
	var token: NSObjectProtocol?
	
	var targetUrl: URL {
//		guard let targetUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("backgroundFile.mp4") else {
//			fatalError("Invalid File URL")
//		}
//
//		return targetUrl
		return BackgroundDownloadManager.shared.targetUrl
	}
	
	var task: URLSessionDownloadTask?
	
//	lazy var session: URLSession = { [weak self] in
//		// Code Input Point #1
//
//		// 컨피규레이션을 백그라운드로 해보자. d
//		let config = URLSessionConfiguration.background(withIdentifier: "SampleSession")
//
//		// Code Input Point #1
//		// 동일한 identifer가 있다면 여기서 새로운 세션이 생성되지 않는다.
//		let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
//		return session
//		}()
	
	let session = BackgroundDownloadManager.shared.session
	
	
	@IBAction func startDownload(_ sender: Any) {
		do {
			let hasFile = try targetUrl.checkResourceIsReachable()
			if hasFile {
				try FileManager.default.removeItem(at: targetUrl)
				print("Removed")
			}
		} catch {
			print(error.localizedDescription)
		}
		updateRecentDownload()
		
		guard let url = URL(string: smallFileUrlStr) else {
			fatalError("Invalid URL")
		}
		
		task = session.downloadTask(with: url)
		task?.resume()
	}
	
	@IBAction func stopDownload(_ sender: Any) {
		session.invalidateAndCancel()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// 세션을 읽고 있다. 지연 저장 속성이 초기화된다. 결과적으로 세션이 생성되고 뷰컨트롤러가 델리게이트로 지정된다. 이미 실행중인 세션에 연결이되면 바로 델리게이트가 호출되고 ui가 업데이트된다.
		_ = session
		updateRecentDownload()
		
		// Code Input Point #4
		token = NotificationCenter.default.addObserver(forName: BackgroundDownloadManager.didWriteDataNotification, object: nil, queue: OperationQueue.main, using: { (noti) in
			guard let userInfo = noti.userInfo else { return }
			guard let downloadedSize = userInfo[BackgroundDownloadManager.totalBytesWrittenKey] as? Int64 else { return }
			guard let totalSize = userInfo[BackgroundDownloadManager.totalBytesExpectedToWriteKey] as? Int64 else { return }
			
			self.sizeLabel.text = "\(self.sizeFormatter.string(fromByteCount: downloadedSize))/\(self.sizeFormatter.string(fromByteCount: totalSize)))"
		})
		// Code Input Point #4
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		session.invalidateAndCancel()
		
		if let token = token {
			NotificationCenter.default.removeObserver(token)
		}
	}
}


//extension BackgroundDownloadViewController: URLSessionDownloadDelegate {
//	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//		sizeLabel.text = "\(sizeFormatter.string(fromByteCount: totalBytesWritten))/\(sizeFormatter.string(fromByteCount: totalBytesExpectedToWrite))"
//	}
//	
//	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//		NSLog(">> %@ %@", self, #function)
//		print(error ?? "Done")
//	}
//	
//	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//		NSLog(">> %@ %@", self, #function)
//		
//		do {
//			_ = try FileManager.default.replaceItemAt(targetUrl, withItemAt: location)
//		} catch {
//			print(error)
//			fatalError(error.localizedDescription)
//		}
//		updateRecentDownload()
//	}
//}
//
//
extension BackgroundDownloadViewController {
	func updateRecentDownload() {
		do {
			let hasFile = try targetUrl.checkResourceIsReachable()
			if hasFile {
				let values = try targetUrl.resourceValues(forKeys: [.fileSizeKey, .creationDateKey])
				if let size = values.fileSize, let date = values.creationDate {
					recentDownloadLabel.text = "\(dateFormatter.string(from: date)) / \(sizeFormatter.string(fromByteCount: Int64(size)))"
				}
			}
		} catch {
			recentDownloadLabel.text = "Not Found / Unknown"
		}
	}
}

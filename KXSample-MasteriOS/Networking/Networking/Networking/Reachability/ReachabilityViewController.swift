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

class ReachabilityViewController: UIViewController {
	
	@IBOutlet weak var sizeLabel: UILabel!
	
	@IBOutlet weak var cellularImageView: UIImageView!
	@IBOutlet weak var wifiImageView: UIImageView!
	
	lazy var formatter: ByteCountFormatter = {
		let f = ByteCountFormatter()
		f.countStyle = .file
		return f
	}()
	
	let wifiOffImage = #imageLiteral(resourceName: "wifi-off.png")
	let wifiOnImage = #imageLiteral(resourceName: "wifi-on.png")
	let cellularOffImage = #imageLiteral(resourceName: "cell-off.png")
	let cellularOnImage = #imageLiteral(resourceName: "cell-on.png")
	
	lazy var session: URLSession = { [weak self] in
		let config = URLSessionConfiguration.default
		
		let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
		return session
		}()
	
	var resumeDataUrl: URL {
		guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("resumeData") else {
			fatalError("Invalid File URL")
		}
		
		return url
	}
	
	var targetUrl: URL {
		guard let targetUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("downloadedFile.mp4") else {
			fatalError("Invalid File URL")
		}
		
		return targetUrl
	}
	
	var task: URLSessionDownloadTask?
	
	@IBAction func startDownload(_ sender: Any) {
		guard let url = URL(string: bigFileUrlStr) else {
			fatalError("Invalid URL")
		}
		
		task = session.downloadTask(with: url)
		task?.resume()
	}
	
	// Code Input Point #1
	var reachability: Reachability?
	// Code Input Point #1
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Code Input Point #2
		reachability = Reachability() // 리처빌리티는 네트워크의 상태가 변경될 때마다, 코드를 실행한다.
		// 클로져로 전달하고 리턴값은 없다.
		reachability?.whenReachable = { reachability in
			self.updateUI(from: reachability)
			self.resumeDownloadIfNeeded()
		}
		reachability?.whenUnreachable = { reachability in
			self.updateUI(from: reachability)
		}
		
		// 이어서 startNotifier 메서드를 호출하고, 네트워크 상태를 감시한다.
		do {
			try reachability?.startNotifier()
		} catch {
			print(error)
		}
		
		// Code Input Point #2
	}
	
	func updateUI(from reachability: Reachability) {
		// Code Input Point #3
		// 네트워크 상태에 따라 이미지 변경.
		switch reachability.connection {
		case .wifi:
			wifiImageView.image = wifiOnImage
			cellularImageView.image = cellularOffImage
		
		case .cellular:
			wifiImageView.image = wifiOffImage
			cellularImageView.image = cellularOnImage
		default:
			wifiImageView.image = wifiOffImage
			cellularImageView.image = cellularOffImage
		}
		// Code Input Point #3
	}
	
	func resumeDownloadIfNeeded() {
		// Code Input Point #6
		// resume데이타 확인하고, 새로운 다운로드 테스크 실행.
		guard reachability?.connection != .some(.none) else { return }
		
		if let resumeData = try? Data(contentsOf: resumeDataUrl) {
			let newDownloadTask = session.downloadTask(withResumeData: resumeData)
			newDownloadTask.resume()
		}
		// Code Input Point #6
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		session.invalidateAndCancel()
	}
	
	// 소멸자
	deinit {
		// Code Input Point #4
		// 네트워크 감시를 중지하고, 리처빌리티 제거
		reachability?.stopNotifier()
		reachability = nil
		// Code Input Point #4
	}
}


extension ReachabilityViewController: URLSessionDownloadDelegate {
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
		sizeLabel.text = "\(formatter.string(fromByteCount: totalBytesWritten))/\(formatter.string(fromByteCount: totalBytesExpectedToWrite))"
	}
	
	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		guard let error = error else { return }
		let downloadError = error as NSError
		
		print(#function)
		print(downloadError)
		
		// Code Input Point #5
		// -1005, NSURLErrorNetworkConnectionLost
		if downloadError.code == NSURLErrorNetworkConnectionLost {
			switch reachability?.connection {
			// 와이파이나 셀룰러 연결되어있으면, 리쥼데이터를 이용하여 이어서 다운받아보자.
			case .some(.wifi), .some(.cellular):
				if let resumeData = downloadError.userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
					let newDownloadTask = session.downloadTask(withResumeData: resumeData)
					newDownloadTask.resume()
				}
			// 나머지 경우는 에어플레인 모드로 전환했거나, 알수없는 이유로 인해 전체네트워크를 사용할 수 없는 경우. -> 네트워크 정상연결을 기다리다가 재시작 할 수 있음.(권장), 리쥼데이타를 파일이나 코어데이터에 저장해두었다가 특정시점 재시작한다. 구현은 복잡하지만, 리쥼데이터가 유실되는 문제는 발생하지 않는다. 여기서는 캐시디렉토리에 리쥼데이터를 저장하겠다.
			default:
				if let resumeData = downloadError.userInfo[NSURLSessionDownloadTaskResumeData] as? Data
				{
					do {
						try resumeData.write(to: resumeDataUrl)
						print("Resume Data Saved")
					} catch {
						print(error)
					}
				}
			}
		}
		
		// Code Input Point #5
	}
	
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
		print(#function)
	}
	
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		print(#function)
		
		guard (try? location.checkResourceIsReachable()) ?? false else {
			return
		}
		
		do {
			_ = try FileManager.default.replaceItemAt(targetUrl, withItemAt: location)
			
			// Code Input Point #7
			if FileManager.default.fileExists(atPath: resumeDataUrl.path) {
				try FileManager.default.removeItem(at: resumeDataUrl)
				print("Resume Data Deleted")
			}
			// Code Input Point #7
		} catch {
			fatalError(error.localizedDescription)
		}
	}
}

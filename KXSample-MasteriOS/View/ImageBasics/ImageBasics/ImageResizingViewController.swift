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
import CoreGraphics

class ImageResizingViewController: UIViewController {
	
	@IBOutlet weak var imageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let targetImage = #imageLiteral(resourceName: "photo")
		let size = CGSize(width: targetImage.size.width / 5, height: targetImage.size.height / 5)
		
		imageView.image = resizingWithBitmapContext(image: targetImage, to: size)
		
	}
}




extension ImageResizingViewController {
	func resizingWithImageContext(image: UIImage, to size: CGSize) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
		
		let frame = CGRect(origin: CGPoint.zero, size: size)
		image.draw(in: frame)
		
		let resultImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return resultImage
	}
}

// uiimage가 아닌, 코어그래픽스 이미지로 바꾸어야 한다.
extension ImageResizingViewController {
	func resizingWithBitmapContext(image: UIImage, to size: CGSize) -> UIImage? {
		guard let cgImage = image.cgImage else {
			return nil
		}
		let bpc = cgImage.bitsPerComponent
		let bpr = cgImage.bytesPerRow
		let colorSpace = cgImage.colorSpace!
		let bitmapInfo = cgImage.bitmapInfo
		
		guard let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: bpc, bytesPerRow: bpr, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
			return nil
		}
		
		context.interpolationQuality = .high
		
		let frame = CGRect(origin: CGPoint.zero, size: size)
		
		context.draw(cgImage, in: frame)
		
		guard let resultImage = context.makeImage() else {
			return nil
		}
		
		return UIImage(cgImage: resultImage)
		
	}
}














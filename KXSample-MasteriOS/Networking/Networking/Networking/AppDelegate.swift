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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   var window: UIWindow?

   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

      return true
   }

	// 앱이 실행되지 않는 상태에서, 백그라운드 세션으로 시작한 테스크가 완료되면, ios는 백그라운드에서 앱을 실행하고 이 메서드를 호출한다.
	func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
		NSLog(">> %@ %@", self, #function)
		
		// 이제 임시파일을 여기서 앱컨테이너로 복사하고, 마지막파리머터로 전달된 컴플리션 핸들러를 호출해야한다. 델리게이트 메서드는 백그라운드 다운로드 뷰 컨트롤러에 구현되어있으나, 이 메서드가 호출된 시점에는 뷰컨트롤러의 인스턴스조차 생성되지 않은 상태이다. 코드를 통해 생성되긴하지만 비효율적이다. 또다른 방법으로 백그라운드 세션을 생성한다음, 앱델리게이트를 urlsession의 델리게이트로 지정하는것을 생각해볼수 있으나 동일한 기능을 수행하는 델리게이트 메서드를 두 파일에서 중복으로 구현하게 된다.. 번거로움.
		// 싱글톤 객체에서 백그라운드 세션을 생성하자.
		
		// 세션 생성
		_ = BackgroundDownloadManager.shared.session
		BackgroundDownloadManager.shared.completionHandler = completionHandler
	}
}


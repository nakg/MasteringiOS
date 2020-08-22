//
//  ViewController.swift
//  FirstStoryboard
//
//  Created by Nakjin Kim on 2020/07/24.
//  Copyright © 2020 multicampus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBAction func presentModalVC(_ sender: Any) {
		// 이동할 스토리보드 객체 생성 ( name에는 .mainstoryboard 앞부분 까지. 두번째는 스토리보드 파일이 포함되어있는 번들. 동일할 때에는 nil)
		let subStoryboard = UIStoryboard(name: "Sub", bundle: nil)
		let vc = subStoryboard.instantiateViewController(withIdentifier: "modalVC")
		vc.modalPresentationStyle = .fullScreen
		present(vc, animated: true, completion: nil)

	}
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}


}


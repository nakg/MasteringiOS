//
//  MyViewController.swift
//  VC
//
//  Created by Nakjin Kim on 2020/07/12.
//  Copyright © 2020 Keun young Kim. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {

	@IBAction func fromCode(_ sender: Any) {
		// nib파일로 뷰컨트롤러 생성. 첫번째 파라미터에 nib명칭 전달.(파일명)
		let vc = CustomNibViewController(nibName: "CustomNibViewController", bundle: nil)
		
		navigationController?.pushViewController(vc, animated: true)
	}
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

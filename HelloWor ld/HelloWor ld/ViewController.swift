//
//  ViewController.swift
//  HelloWor ld
//
//  Created by Nakjin Kim on 2020/02/23.
//  Copyright © 2020 multicampus. All rights reserved.
// hi

import UIKit

class ViewController: UIViewController {
 
    @IBOutlet weak var label: UILabel!
    
    @IBAction func updateLabel(_ sender: Any) {
        label.text = "Hello, iOS" 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


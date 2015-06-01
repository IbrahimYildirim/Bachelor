//
//  SignupStepOneViewController.swift
//  SportLook
//
//  Created by Terminator on 01/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class SignupStepOneViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override init() {
        super.init(nibName: "SignupStepOneViewController", bundle: nil)
    }

    @IBAction func nextButtonTapped(sender: UIButton) {
        
        let controller = SignupStepTwoViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

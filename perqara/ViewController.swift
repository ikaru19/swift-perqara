//
//  ViewController.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 06/02/23.
//

import UIKit
import RxSwift
import RxAlamofire
import Cleanse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (UIApplication.shared.delegate as? ProvideInjectorResolver)?.injectorResolver.inject(self)
    }

    func injectProperties(
            viewController: TaggedProvider<MyBaseUrl>
    ){

    }
}


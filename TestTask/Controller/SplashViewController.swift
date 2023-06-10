//
//  SplashViewController.swift
//  TestTask
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigateToWelcome()
    }
    
    // navigate to the welcom screen
    private func navigateToWelcome() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let vc = UIStoryboard.init(name: "Main",
                                       bundle: Bundle.main)
                .instantiateViewController(withIdentifier: "WelcomeViewController")
            as? WelcomeViewController
            UIWindow.key.rootViewController = vc
            UIWindow.key.makeKeyAndVisible()
        }
    }
}





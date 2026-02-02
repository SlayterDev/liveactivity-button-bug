//
//  ViewController.swift
//  testapp
//
//  Created by Bradley Slayter on 1/8/26.
//

import UIKit
import ActivityKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var pushTokenLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func requestPushToken(_ sender: Any) {
        Task {
            for await tokenData in Activity<LiveActivityAttributes>.pushToStartTokenUpdates {
                let tokenString = tokenData.reduce("") {
                    $0 + String(format: "%02x", $1)
                }
                print("PUSH TO START: \(tokenString)")
                await MainActor.run {
                    pushTokenLabel.text = tokenString
                }
            }
        }
    }
    
    @IBAction func copyPushToken(_ sender: Any) {
        UIPasteboard.general.string = pushTokenLabel.text
    }
}


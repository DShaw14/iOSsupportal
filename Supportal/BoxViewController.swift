//
//  BoxViewController.swift
//  Supportal
//
//  Created by Zachary A. Menken on 10/20/16.
//  Copyright © 2016 Oak Labs. All rights reserved.
//

import UIKit
import Starscream
import SlackKit

class BoxViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var highPriority: UISwitch!
    @IBAction func submitButton(_ sender: UIButton) {
        if highPriority.isOn {
            let incoming = IncomingWebhook(url: "https://hooks.slack.com/services/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", channel:"#random", username:"zmenken")
            let message = Response(text: "iOS Test Message")
            incoming.postMessage(message)
            highPriority.setOn(false, animated:true)
        } else {
            highPriority.setOn(false, animated:true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

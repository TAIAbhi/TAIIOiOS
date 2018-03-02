//
//  ViewController.swift
//  Tagabout
//
//  Created by Karun Pant on 11/02/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var titleMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleMessage.text = UILocalizationConstants.tagline
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as!
        AVPlayerViewController
        let path = Bundle.main.path(forResource: "movie", ofType: "mov")
        let url = URL(fileURLWithPath: path!)
        destination.player = AVPlayer(url: url)
        
    }
    @IBAction func didTapsyncConacts(_ sender: UIButton) {
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


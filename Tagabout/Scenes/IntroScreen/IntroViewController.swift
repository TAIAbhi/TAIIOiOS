//
//  IntroViewController.swift
//  Tagabout
//
//  Created by Arun Jangid on 03/08/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class IntroViewController: ViewController {

    static func introViewController() -> IntroViewController{
        return IntroViewController.instantiate(fromAppStoryboard: .UserStory)
    }
    
    private lazy var introRouter = IntroRouter(with: self)

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showVideo(_ sender: UIButton) {
        let destination = AVPlayerViewController()
        let path = Bundle.main.path(forResource: "movie", ofType: "mov")
        let url = URL(fileURLWithPath: path!)
        destination.player = AVPlayer(url: url)
        destination.showsPlaybackControls = true
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: destination.player?.currentItem)
        
        self.present(destination, animated: true) {
            destination.player?.play()
        }
    }
    
    @IBAction func actionSkip(_ sender: UIButton) {
        introRouter.navigateToLanding()
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification){
        self.introRouter.navigateToLanding()
    }
    

}

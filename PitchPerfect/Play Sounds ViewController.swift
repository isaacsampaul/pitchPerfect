//
//  Play Sounds ViewController.swift
//  PitchPerfect
//
//  Created by Isaac sam paul on 9/18/16.
//  Copyright © 2016 Isaac sam paul. All rights reserved.
//

import UIKit
import AVFoundation

class Play_Sounds_ViewController: UIViewController {
    var RecordedAudioURL:NSURL!
    var Audiofile: AVAudioFile!
    var Audioengine: AVAudioEngine!
    var Audioplayernode: AVAudioPlayerNode!
    var stoptimer: Timer!
    
    
    
    @IBOutlet weak var snail: UIButton!
    @IBOutlet weak var rabbit: UIButton!
    @IBOutlet weak var chipmunk: UIButton!
    @IBOutlet weak var darkvader: UIButton!
    @IBOutlet weak var echo: UIButton!
    @IBOutlet weak var reverb: UIButton!
    @IBOutlet weak var stop: UIButton!
    
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerStackView1: UIStackView!
    @IBOutlet weak var innerStackView2: UIStackView!
    @IBOutlet weak var innerStackView3: UIStackView!
    @IBOutlet weak var innerStackView4: UIStackView!
    
    
    enum buttontype: Int {case slow=0,fast,chipmunk1,vader1,echo1,reverb1}
    
    @IBAction func playsoundforbutton(sender: UIButton)
    {
        
        switch(buttontype(rawValue: sender.tag)!)
        {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk1:
            playSound(pitch: 1000)
        case .vader1:
            playSound(pitch: -1000)
        case .echo1:
            playSound(echo: true)
        case .reverb1:
            playSound(reverb: true)
        }
        configureUI(playState: .Playing)
    }
    
    @IBAction func stopbuttonpressed(sender: AnyObject)
    {
        print("stop button is pressed")
        stopAudio() 
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        snail.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        rabbit.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        chipmunk.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        darkvader.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        echo.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        reverb.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        stop.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI(playState: .NotPlaying)
    }

    func setInnerStackViewsAxis(axisStyle: UILayoutConstraintAxis)  {
        self.innerStackView1.axis = axisStyle
        self.innerStackView2.axis = axisStyle
        self.innerStackView3.axis = axisStyle
        self.innerStackView4.axis = axisStyle
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
        {
        coordinator.animate(alongsideTransition: { (context) -> Void in
            let orientation = UIApplication.shared.statusBarOrientation
            
            if orientation.isPortrait{
                self.outerStackView.axis = .vertical
                self.setInnerStackViewsAxis(axisStyle: .horizontal)
            } else {
                self.outerStackView.axis = .horizontal
                self.setInnerStackViewsAxis(axisStyle: .vertical)
            }
            }, completion: nil)
    }
    
}


//  ViewController.swift
//  PitchPerfect
//
//  Created by Isaac sam paul on 9/18/16.
//  Copyright © 2016 Isaac sam paul. All rights reserved.
//

import UIKit
import AVFoundation

class soundrecorder: UIViewController,AVAudioRecorderDelegate {

    @IBOutlet weak var Recording: UILabel!
    @IBOutlet weak var record: UIButton!
    @IBOutlet weak var stoprecord: UIButton!
    var audiorecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func recordingInitialization()
    {
        Recording.text = "Recording is in progress"
        stoprecord.isEnabled = true
        record.isEnabled = false
    }
    
    func stopRecordInitializtions()
    {
        stoprecord.isEnabled = false
        record.isEnabled = true
        Recording.text = "Tap to record"
    }

    @IBAction func RecordAudio(_ sender: AnyObject)
    {
        
        recordingInitialization()
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        
        let recordingName = "recordedvoice.wav"
        let patharray = [dirPath,recordingName]
        let filepath = NSURL.fileURL(withPathComponents:patharray)
        print(filepath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audiorecorder = AVAudioRecorder(url: filepath!, settings: [:])
        audiorecorder.delegate = self
        audiorecorder.isMeteringEnabled = true
        audiorecorder.prepareToRecord()
        audiorecorder.record()
            }
    @IBAction func StopRecording(_ sender: AnyObject)
    {
        
        stopRecordInitializtions()
        audiorecorder.stop()
        let audiosession = AVAudioSession.sharedInstance()
        try! audiosession.setActive(false)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        stoprecord.isEnabled = false
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("audio finished recording")
        if (flag)
        {
          self.performSegue(withIdentifier: "stoprecording", sender: audiorecorder.url)
        }
        else
        {
            print("saving recording failed")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "stoprecording")
        {
            let playsoundvc = segue.destination as! Play_Sounds_ViewController
            let RecordedAudioURL =  sender as! NSURL
            playsoundvc.RecordedAudioURL = RecordedAudioURL
        }
    }
}


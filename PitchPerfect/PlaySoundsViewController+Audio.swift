//
//  PlaySoundsViewController+Audio.swift
//  PitchPerfect
//
//  Copyright © 2016 Udacity. All rights reserved.
//
import UIKit
import AVFoundation

extension Play_Sounds_ViewController: AVAudioPlayerDelegate {
    struct Alerts {
        static let DismissAlert = "Dismiss"
        static let RecordingDisabledTitle = "Recording Disabled"
        static let RecordingDisabledMessage = "You've disabled this app from recording your microphone. Check Settings."
        static let RecordingFailedTitle = "Recording Failed"
        static let RecordingFailedMessage = "Something went wrong with your recording."
        static let AudioRecorderError = "Audio Recorder Error"
        static let AudioSessionError = "Audio Session Error"
        static let AudioRecordingError = "Audio Recording Error"
        static let AudioFileError = "Audio File Error"
        static let AudioEngineError = "Audio Engine Error"
    }
    
    // raw values correspond to sender tags
    enum PlayingState { case Playing, NotPlaying }

    
    // MARK: Audio Functions
    
    func setupAudio() {
        // initialize (recording) audio file
        do {
            Audiofile = try AVAudioFile(forReading: RecordedAudioURL as URL)
        } catch {
            showAlert(title: Alerts.AudioFileError, message: String(describing: error))
        }
        print("Audio has been setup")
    }
    
    func playSound(rate rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, reverb: Bool = false) {
        
        // initialize audio engine components
        Audioengine = AVAudioEngine()
        
        // node for playing audio
        Audioplayernode = AVAudioPlayerNode()
        Audioengine.attach(Audioplayernode)
        
        // node for adjusting rate/pitch
        let changeRatePitchNode = AVAudioUnitTimePitch()
        if let pitch = pitch {
            changeRatePitchNode.pitch = pitch
        }
        if let rate = rate {
            changeRatePitchNode.rate = rate
        }
        Audioengine.attach(changeRatePitchNode)
        
        // node for echo
        let echoNode = AVAudioUnitDistortion()
        echoNode.loadFactoryPreset(.multiEcho1)
        Audioengine.attach(echoNode)
        
        // node for reverb
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.cathedral)
        reverbNode.wetDryMix = 50
        Audioengine.attach(reverbNode)
        
        // connect nodes
        if echo == true && reverb == true {
            connectAudioNodes(nodes: Audioplayernode, changeRatePitchNode, echoNode, reverbNode, Audioengine.outputNode)
        } else if echo == true {
            connectAudioNodes(nodes: Audioplayernode, changeRatePitchNode, echoNode, Audioengine.outputNode)
        } else if reverb == true {
            connectAudioNodes(nodes: Audioplayernode, changeRatePitchNode, reverbNode, Audioengine.outputNode)
        } else {
            connectAudioNodes(nodes: Audioplayernode, changeRatePitchNode, Audioengine.outputNode)
        }
        
        // schedule to play and start the engine!
        Audioplayernode.stop()
        Audioplayernode.scheduleFile(Audiofile, at: nil) {
            
            var delayInSeconds: Double = 0
            
            if let lastRenderTime = self.Audioplayernode.lastRenderTime, let playerTime = self.Audioplayernode.playerTime(forNodeTime: lastRenderTime) {
                
                if let rate = rate {
                    delayInSeconds = Double(self.Audiofile.length - playerTime.sampleTime) / Double(self.Audiofile.processingFormat.sampleRate) / Double(rate)
                } else {
                    delayInSeconds = Double(self.Audiofile.length - playerTime.sampleTime) / Double(self.Audiofile.processingFormat.sampleRate)
                }
            }
            
            // schedule a stop timer for when audio finishes playing
            self.stoptimer = Timer(timeInterval: delayInSeconds, target: self, selector: "stopAudio", userInfo: nil, repeats: false)
            RunLoop.main.add(self.stoptimer!, forMode: RunLoopMode.defaultRunLoopMode)
        }
        
        do {
            try Audioengine.start()
        } catch {
            showAlert(title: Alerts.AudioEngineError, message: String(describing: error))
            return
        }
        
        // play the recording!
        Audioplayernode.play()
    }
    
    
    // MARK: Connect List of Audio Nodes
    
    func connectAudioNodes(nodes: AVAudioNode...) {
        for x in 0..<nodes.count-1 {
            Audioengine.connect(nodes[x], to: nodes[x+1], format: Audiofile.processingFormat)
        }
    }
    
    func stopAudio() {
        
        if let stoptimer = stoptimer {
            stoptimer.invalidate()
        }
        
        configureUI(playState: .NotPlaying)
        
        if let Audioplayernode = Audioplayernode {
            Audioplayernode.stop()
        }
        
        if let Audioengine = Audioengine {
            Audioengine.stop()
            Audioengine.reset()
        }
    }
    
    
    // MARK: UI Functions

    func configureUI(playState: PlayingState) {
        switch(playState) {
        case .Playing:
            setPlayButtonsEnabled(enabled: false)
            stop.isEnabled = true
        case .NotPlaying:
            setPlayButtonsEnabled(enabled: true)
            stop.isEnabled = false
        }
    }
    
    func setPlayButtonsEnabled(enabled: Bool) {
        snail.isEnabled = enabled
        chipmunk.isEnabled = enabled
        rabbit.isEnabled = enabled
        darkvader.isEnabled = enabled
        echo.isEnabled = enabled
        reverb.isEnabled = enabled
    }

    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
}










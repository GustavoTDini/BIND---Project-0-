//
//  RecordSoundsViewControler.swift
//  Pitch Perfect
//
//  Created by Gustavo Dini on 29/11/18.
//  Copyright © 2018 Gustavo Dini. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewControler: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    // MARK: Outlets

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    
    
    // MARK: Actions

    @IBAction func recordButtonAction(_ sender: Any) {
        showUI(true)
        createSoundFlie()
    }
    
    @IBAction func stopRecordButtonAction(_ sender: Any) {
        showUI(false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
   // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showUI(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            createAlertMessage(message: "Recording was not Successful")
        }
    }
    
    // MARK: Helper Functions
    
    func showUI(_ recording: Bool = false){
        stopRecordingButton.isEnabled = recording
        recordButton.isEnabled = !recording
        recordLabel.text = recording ? "Recording in Progress":"Tap to Record"
    }
    
    func createSoundFlie(){
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options:AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func createAlertMessage(message: String){
        let alert = UIAlertController(title: "Ops!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}


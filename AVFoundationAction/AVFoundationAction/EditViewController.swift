//
//  EditViewController.swift
//  AVFoundationAction
//
//  Created by EzioChan on 2020/5/7.
//  Copyright © 2020 Ezio. All rights reserved.
//

import UIKit
import AVFoundation

class EditViewController: UIViewController {
    
    @IBOutlet weak var playerImgv: UIImageView!
    var composotion:AVMutableComposition!
    var firstAsset:AVAsset!
    var secAsset:AVAsset!
    var path:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        path = Bundle.main.path(forResource: "IMG_2735", ofType: "mp4")
        let url = URL.init(fileURLWithPath: path)
        let options = [AVURLAssetAllowsCellularAccessKey:false,AVURLAssetPreferPreciseDurationAndTimingKey:true]
        firstAsset = AVURLAsset.init(url: url, options: options)
        
        let voicePath = Bundle.main.path(forResource: "SuperMarioBros", ofType: "mp3")
        let url2 = URL.init(fileURLWithPath: voicePath!)
        secAsset = AVURLAsset.init(url: url2)
        
        let voicePath2 = Bundle.main.path(forResource: "MaiDou", ofType: "mp3")
        let url3 = URL.init(fileURLWithPath: voicePath2!)
        let thireAsset = AVURLAsset.init(url: url3)
        
        let videoAssetTrack = firstAsset.tracks(withMediaType: .video).first
        let audioAssetTrack = secAsset.tracks(withMediaType: .audio).first
        let audioAssetTrack2 = thireAsset.tracks(withMediaType: .audio).first
        
        //合成器
        composotion = AVMutableComposition.init()
        //视频轨道
        let videoCompostiontrack = composotion.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        //音频轨道1
        let audioCompostiontrack = composotion.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        //音轨2
        let audioCompositiontrack2 = composotion.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        //为视频轨道放入视频
        let v = 0.8 * Float(firstAsset.duration.seconds) * videoAssetTrack!.nominalFrameRate
        let e = 0.1 * Float(firstAsset.duration.seconds) * videoAssetTrack!.nominalFrameRate
        let v_start = CMTime.init(value: CMTimeValue(v), timescale: CMTimeScale(videoAssetTrack!.nominalFrameRate))
        let v_endTime = CMTime.init(value: CMTimeValue(e), timescale: CMTimeScale(videoAssetTrack!.nominalFrameRate))
        print(v_start.seconds)
        print(v_endTime.seconds)
        let theTime = CMTimeRangeMake(start: v_start, duration: v_endTime)
        
        try?videoCompostiontrack?.insertTimeRange(theTime, of: videoAssetTrack!, at: CMTime.zero)
        //为音频轨道放入音频
        let theTimeAudio = CMTimeRangeMake(start: CMTime.zero, duration: CMTime.init(value: CMTimeValue(e*0.65), timescale: CMTimeScale(videoAssetTrack!.nominalFrameRate)))
        try?audioCompostiontrack?.insertTimeRange(theTimeAudio, of: audioAssetTrack!, at: CMTime.zero)
        //为音频轨道放入音频2
        let theTimeAudio2 = CMTimeRangeMake(start: CMTime.zero, duration: (audioAssetTrack2?.timeRange.duration)!)
        
        let st2 = CMTime.init(value: CMTimeValue(e*0.65), timescale: CMTimeScale(videoAssetTrack!.nominalFrameRate))
        print(st2.seconds)
        try?audioCompositiontrack2?.insertTimeRange(theTimeAudio2, of: audioAssetTrack2!, at: st2)
        
        
        
    
        let exporter = AVAssetExportSession.init(asset: composotion, presetName: AVAssetExportPresetHighestQuality)
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let filePath = path!+"/test.mp4"
        try?FileManager.default.removeItem(atPath: filePath)
//        FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
        
        exporter?.outputURL = URL.init(fileURLWithPath: filePath)
        
        exporter?.outputFileType = .mp4
        exporter?.shouldOptimizeForNetworkUse = true
        exporter?.exportAsynchronously(completionHandler: {
            if exporter?.error != nil{
                print(exporter?.error)
            }else{
            
            }
            DispatchQueue.main.async {
                self.playIt(url: URL.init(fileURLWithPath: filePath))
            }
        })
    }
    
    func playIt(url:URL) {
        let item = AVPlayerItem.init(url: url)
        let player = AVPlayer.init(playerItem: item)
        let layer = AVPlayerLayer.init(player: player)
        layer.frame = playerImgv.frame
        layer.videoGravity = .resizeAspect
        playerImgv.layer.addSublayer(layer)

        player.play()

    }

    func createcomposition()  {
        
    }

}

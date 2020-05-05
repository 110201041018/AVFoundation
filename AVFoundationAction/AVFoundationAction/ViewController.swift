//
//  ViewController.swift
//  AVFoundationAction
//
//  Created by EzioChan on 2020/5/5.
//  Copyright © 2020 Ezio. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var path:String!
    var mainAsset:AVAsset!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        path = Bundle.main.path(forResource: "IMG_0830", ofType: "MOV")
        let url = URL.init(fileURLWithPath: path)
        let options = [AVURLAssetAllowsCellularAccessKey:false,AVURLAssetPreferPreciseDurationAndTimingKey:true]
        mainAsset = AVURLAsset.init(url: url, options: options)
    
        
        let d = CMTimeGetSeconds(mainAsset.duration)
        let p = mainAsset.providesPreciseDurationAndTiming
        print("时长：\(d)，可用时间准确性：\(p)")
        
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let cc = mainAsset.creationDate
        let createDate = formatter.string(from: cc?.dateValue ?? Date.init())
        print("创建时间：\(createDate)")
        
        
        let rate = mainAsset.preferredRate //速率
        print("rate:\(rate)")
        
        let volume = mainAsset.preferredVolume //音量
        print("volume:\(volume)")
        
        let canPlay = mainAsset.isPlayable //是否支持播放
        print("isPlayable:\(canPlay)")
        
        let export = mainAsset.isExportable //是否支持导出
        print("exportable:\(export)")
        
        let reabable = mainAsset.isReadable //是否可读取内容
        print("readable:\(reabable)")
        
        let composable = mainAsset.isComposable //是否可合成
        print("composable:\(composable)")
        
        let hasProtect = mainAsset.hasProtectedContent //是否受保护
        print("hasProtect:\(hasProtect)")
        
        
        let compatible = mainAsset.isCompatibleWithSavedPhotosAlbum
        print("是否可以写入相册：\(compatible)")
        
        track()
      
    }
    
    func track() {
        for track in mainAsset.tracks {
            print("trackID:\(track.trackID)")
            print("mediaType:\(track.mediaType.rawValue)")
            
            //print("formatDescription:\(track.formatDescriptions)")
        }
    }


}


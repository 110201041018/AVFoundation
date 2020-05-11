//
//  ViewController.swift
//  AVFoundationAction
//
//  Created by EzioChan on 2020/5/5.
//  Copyright © 2020 Ezio. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    
    var path:String!
    var mainAsset:AVAsset!
    var imageGen:AVAssetImageGenerator!
    @IBOutlet weak var imagesTable: UITableView!
    var imagesArray:[UIImage]! = []
    @IBOutlet weak var slider: UISlider!
    var tmpValue:Float!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imagesTable.delegate = self
        imagesTable.dataSource = self
        imagesTable.rowHeight = 72
        imagesTable.register(UITableViewCell.self, forCellReuseIdentifier: "testCell")
        
        path = Bundle.main.path(forResource: "IMG_2735", ofType: "mp4")
        let url = URL.init(fileURLWithPath: path)
        let options = [AVURLAssetAllowsCellularAccessKey:false,AVURLAssetPreferPreciseDurationAndTimingKey:true]
        mainAsset = AVURLAsset.init(url: url, options: options)
        basicData()
        track()
        getAllFrame()
        initUI()
        
    }
    
    func initUI() {
        slider.maximumValue = 1.0;
        slider.minimumValue = 0.0;
        slider.setValue(0.0, animated: true)
        slider.addTarget(self, action: #selector(changeAction), for: .valueChanged)
        imageGen = AVAssetImageGenerator.init(asset: mainAsset)
        imageGen.maximumSize = CGSize.init(width: 1170, height: 540)
        imageGen.appliesPreferredTrackTransform = true
    }
    
    @objc func changeAction(){
        print("slider.value:\(slider.value)")
       
        let imgc = mainAsset.tracks(withMediaType: .video).count
        var track:AVAssetTrack!
        if imgc == 1 {
            track = mainAsset.tracks(withMediaType: .video).first
        }
        let v = slider.value * Float(mainAsset.duration.seconds) * track.nominalFrameRate
        let t = CMTime.init(value: CMTimeValue(v), timescale: CMTimeScale(track.nominalFrameRate))
        imageGen.cancelAllCGImageGeneration()
        guard let img = try?self.imageGen.copyCGImage(at: t, actualTime: nil) else {
            return
        }
        print("get a img by asset")
        self.thumbImageView.image = UIImage.init(cgImage: img)
//        DispatchQueue.global().async {
//            guard let img = try?self.imageGen.copyCGImage(at: t, actualTime: nil) else {
//                return
//            }
//            DispatchQueue.main.async {
//                print("get a img by asset")
//                self.thumbImageView.image = UIImage.init(cgImage: img)
//            }
//
//        }
    }
    
    func getAssetAttrabute(){
        
        let mateData = mainAsset.metadata(forFormat: .quickTimeUserData)
        print("元数据标记数组\(mateData)")
        
    }
    
    func getAllFrame(){
        
        let imgc = mainAsset.tracks(withMediaType: .video).count
        var track:AVAssetTrack!
        if imgc == 1 {
            track = mainAsset.tracks(withMediaType: .video).first
        }
        let gem = AVAssetImageGenerator.init(asset: mainAsset)
        gem.maximumSize = CGSize.init(width: 128, height: 72)
        gem.apertureMode = AVAssetImageGenerator.ApertureMode.cleanAperture
        var array:[NSValue]! = []
        let d = mainAsset.duration.seconds
        let all = d * Double(track.nominalFrameRate)
        
        let numberGet = Int(d*5)//每秒里面取5帧
        let scan = Int(all)/numberGet //取帧间隔
        for item in 0..<numberGet {
            let value = item*scan
            let ctvalue = CMTime.init(value: CMTimeValue(value), timescale: CMTimeScale(track!.nominalFrameRate)) as NSValue
            array.append(ctvalue)
        }
        
        gem.generateCGImagesAsynchronously(forTimes: array) { (time1, cgimg, time2, result, error) in
            if let _cgimg = cgimg {
                let img = UIImage.init(cgImage: _cgimg)
                self.imagesArray.append(img)
                DispatchQueue.main.async {
                    self.imagesTable.reloadData()
                }
                //print("get a img by asset\(img)")
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testCell")!
        cell.imageView?.image = imagesArray[indexPath.row]
        return cell
    }
    
    
    func basicData() {
        
        let d = CMTimeGetSeconds(mainAsset.duration)
        let p = mainAsset.providesPreciseDurationAndTiming
        print("时长：\(d)，可用时间准确性：\(p) \(mainAsset.duration.timescale)")
        
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
        
        
    }
    
    /// 查看所有轨道的数据信息
    func track() {
        
        for track in mainAsset.tracks {
            print("trackID:\(track.trackID)")
            print("mediaType:\(track.mediaType.rawValue)")
            print("nominalFrameRate:\(track.nominalFrameRate)")
            print("minFrameDuration:\(track.minFrameDuration.seconds)")
            print("formatDescription:\(track.formatDescriptions)\n\n\n\n\n\\n\n\n\n\n\n")
            
        }
    }
    
    
    
    
}


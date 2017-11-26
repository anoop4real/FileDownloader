//
//  DownLoadTableViewCell.swift
//  FileDownLoader
//
//  Created by anoopm on 13/05/17.
//  Copyright © 2017 anoopm. All rights reserved.
//

import UIKit

protocol DownLoadTableViewCellDelegate: class {
    
    func downloadCompleted()
    func downloadFailedWithError(message:String)
}
class DownLoadTableViewCell: UITableViewCell {
    
    @IBOutlet weak var startDownloadbtn:UIButton!
    @IBOutlet weak var stopDownloadbtn:UIButton!
    @IBOutlet weak var fileNameLabel:UILabel!
    @IBOutlet weak var downLoadReadyLabel:UILabel!
    @IBOutlet weak var downloadProgressView:UIProgressView!
    
    weak var cellDelegate:DownLoadTableViewCellDelegate!
    
    var downloadData:DownLoadData!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    // Method to start/ pause file download
    @IBAction func startOrPauseDownloadingSingleFile(_ sender: UIButton) {
        
        startOrPauseDownload()
    }
    
    func startOrPauseDownload(){
        
        // If not downloading then start a new task
        if !self.downloadData.isDownloading{
            
            if self.downloadData.taskIdentifier == 0{
                self.downloadData.startDownload(completion: { [weak self] (result) in
                    self?.handleDownloadResult(result: result)
                    }, progressHandler: {[weak self] (percentage) in
                        self?.handleProgress(percentage: percentage)
                })
            }else{
                self.downloadData.resumeDownload(completion: {[weak self] (result) in
                    self?.handleDownloadResult(result: result)
                    }, progressHandler: { [weak self](percentage) in
                        self?.handleProgress(percentage: percentage)
                })
            }
            
        }else{
            
            // Pause
            self.downloadData.pauseDownload()
        }
        // Update the view based on download status.
        updateView()
    }
    
    func stopDownload(){
        
        self.downloadData.stopDownload()
        updateView()
    }
    func handleDownloadResult(result:Result<Bool, Error>){
        
        switch result{
        case .success:
            self.cellDelegate?.downloadCompleted()
        case .error(let error):
            self.cellDelegate?.downloadFailedWithError(message: error.localizedDescription)
        }
        DispatchQueue.main.async {
            self.updateView()
        }
    }
    
    func handleProgress(percentage:Float){
        DispatchQueue.main.async {
            self.downloadProgressView.progress = percentage
        }
    }
    @IBAction func stopDownloading(_ sender: UIButton) {
        
        stopDownload()
    }
    
    func configureCell(with downloadInfo:DownLoadData){
        
        // Set the download info into the cell
        self.downloadData = downloadInfo
        
        fileNameLabel.text = downloadInfo.fileTitle
        if self.downloadData.groupDownloadON {
            startOrPauseDownload()
            // reset flag
            self.downloadData.groupDownloadON = false
        }
        if self.downloadData.groupStopDownloadON{
            
            stopDownload()
            self.downloadData.groupStopDownloadON = false
        }
        updateView()
        
        
    }
    func updateView(){
        
        if !self.downloadData.isDownloading {
            // Hide the progress view and disable the stop button.
            downloadProgressView.isHidden = true
            stopDownloadbtn.isEnabled = false
            // Set a flag value depending on the downloadComplete property of the fdi object.
            // Using it will be shown either the start and stop buttons, or the Ready label.
            let hideControls: Bool = (self.downloadData.isDownloadComplete) ? true : false
            startDownloadbtn.isHidden = hideControls
            stopDownloadbtn.isHidden = hideControls
            downLoadReadyLabel.isHidden = !hideControls
            startDownloadbtn.setImage(#imageLiteral(resourceName: "download"), for: .normal)
        }
        else {
            // Show the progress view and update its progress, change the image of the start button so it shows
            // a pause icon, and enable the stop button.
            downloadProgressView.isHidden = false
            stopDownloadbtn.isEnabled = true
            startDownloadbtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
    }
}

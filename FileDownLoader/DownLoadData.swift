//
//  DownLoadDataStore.swift
//  FileDownLoader
//
//  Created by anoopm on 14/05/17.
//  Copyright © 2017 anoopm. All rights reserved.
//

import Foundation

class DownLoadData: NSObject {
    var fileTitle: String = ""
    var downloadSource: String = ""
    var downloadTask: URLSessionDownloadTask?
    var taskResumeData: Data?
    var downloadProgress: Float = 0.0
    var isDownloading: Bool = false
    var isDownloadComplete: Bool = false
    var taskIdentifier: Int = 0
    var groupDownloadON:Bool = false
    var groupStopDownloadON:Bool = false
    
    init(with title:String, and source:String){
        self.fileTitle = title
        self.downloadSource = source
        super.init()
        
    }
    
    func startDownload(completion:@escaping (Result<Bool, Error>)->Void,progressHandler:@escaping (Float)->Void ){
        let sharedNetworkmanager = NetworkDataManager.sharedNetworkmanager
        let url = URL(string: self.downloadSource)!
        self.downloadTask = sharedNetworkmanager.downloadFileWithRequest(URLRequest(url: url), completion: {[weak self] (result) in
            switch(result){
            case .success:
                self?.handleDownloadSuccess()
                completion(.success(true))
            case .error(let error):
                self?.handleDownloadError()
                completion(.error(error))
            }
            }, progressHandler: { (percentage) in
                progressHandler(percentage)
        })
        self.taskIdentifier = (self.downloadTask?.taskIdentifier)!
        self.downloadTask?.resume()
        self.isDownloading = true
    }
    func resumeDownload(completion:@escaping (Result<Bool, Error>)->Void,progressHandler:@escaping (Float)->Void ){
        let sharedNetworkmanager = NetworkDataManager.sharedNetworkmanager
        self.downloadTask = sharedNetworkmanager.resumeDownloadWithData(resumeData: self.taskResumeData!, completion: { [weak self](result) in
            switch(result){
            case .success:
                self?.handleDownloadSuccess()
                completion(.success(true))
            case .error(let error):
                self?.handleDownloadError()
                completion(.error(error))
            }
            }, progressHandler: { (percentage) in
                progressHandler(percentage)
        })
        self.taskIdentifier = (self.downloadTask?.taskIdentifier)!
        self.downloadTask?.resume()
        self.isDownloading = true
        
    }
    
    func pauseDownload(){
        self.downloadTask?.cancel(byProducingResumeData: { [weak self] (resumeData) in
            if resumeData != nil{
                self?.taskResumeData = resumeData
            }
            self?.cleanUpHandlers()
            
        })
        self.isDownloading = false
    }
    
    func stopDownload(){
        
        if self.isDownloading{
            self.downloadTask?.cancel()
            self.isDownloading = false
            self.cleanUpHandlers()
            self.taskIdentifier = 0
        }
    }
    func cleanUpHandlers(){
        
        // remove the completion handlers from the network manager as resume is taken as a new task.
        let sharedManager = NetworkDataManager.sharedNetworkmanager
        sharedManager.removeCompletionHandlerForTask(identifier: (self.taskIdentifier))
        sharedManager.removeProgressHandlerForTask(identifier: (self.taskIdentifier))
    }
    func handleDownloadSuccess(){
        
        self.taskIdentifier = 0
        self.isDownloading = false
        self.isDownloadComplete = true
        self.taskResumeData = nil
    }
    func handleDownloadError(){
        
        self.taskIdentifier = 0
        self.isDownloading = false
        self.isDownloadComplete = false
        self.taskResumeData = nil
    }
}

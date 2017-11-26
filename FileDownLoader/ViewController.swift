//
//  ViewController.swift
//  FileDownLoader
//
//  Created by anoopm on 13/05/17.
//  Copyright © 2017 anoopm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var fileTableView:UITableView!

    fileprivate var fileDownLoadDataArray:[DownLoadData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeDownLoadTestData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeDownLoadTestData(){
        let data = DownLoadData(with: "iOS Programming Guide", and: "https://developer.apple.com/library/ios/documentation/iphone/conceptual/iphoneosprogrammingguide/iphoneappprogrammingguide.pdf")

        fileDownLoadDataArray.append(data)
        fileDownLoadDataArray.append(DownLoadData(with: "Human Interface Guidelines", and: "https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/MobileHIG.pdf"))
        fileDownLoadDataArray.append(DownLoadData(with: "Networking Overview", and: "https://developer.apple.com/library/ios/documentation/NetworkingInternetWeb/Conceptual/NetworkingOverview/NetworkingOverview.pdf"))
        fileDownLoadDataArray.append(DownLoadData(with: "AV Foundation", and: "https://developer.apple.com/library/ios/documentation/AudioVideo/Conceptual/AVFoundationPG/AVFoundationPG.pdf"))
        fileDownLoadDataArray.append(DownLoadData(with: "iPhone User Guide", and: "http://manuals.info.apple.com/MANUALS/1000/MA1565/en_US/iphone_user_guide.pdf"))
    }
        
    @IBAction func startAllDownloads(_ sender: UIButton) {
        
        for downloadItem in fileDownLoadDataArray{
            
            downloadItem.groupDownloadON = true
        }
        fileTableView.reloadData()
    }
    
    @IBAction func stopAllDownloads(_ sender: UIButton) {
        
        for downloadItem in fileDownLoadDataArray{
            
            downloadItem.groupStopDownloadON = true
        }
        fileTableView.reloadData()
    }
    
    @IBAction func initializeAll(_ sender: UIButton) {
    }


}

extension ViewController:UITableViewDataSource, UITableViewDelegate, DownLoadTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return fileDownLoadDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cellIdentifier = "downloadcell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DownLoadTableViewCell
        let downloadData = fileDownLoadDataArray[indexPath.row]
        cell.configureCell(with: downloadData)
        cell.cellDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 60.0
    }
    func downloadCompleted(){
        
        print("Download complete")
    }
    func downloadFailedWithError(message:String){
        
        print("Download erros")
    }
}


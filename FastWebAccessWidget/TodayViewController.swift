//
//  TodayViewController.swift
//  FastWebAccessWidget
//
//  Created by nakajimashunta on 2017/03/08.
//  Copyright © 2017年 ShuntaNakajima. All rights reserved.
//

import UIKit
import NotificationCenter
import Kanna
import Alamofire

class TodayViewController: UIViewController, NCWidgetProviding,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tableview : UITableView!
    var URLS = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.register(
            UINib(nibName: "UrlsTableViewCell", bundle: nil),
            forCellReuseIdentifier: "Cell"
        )
        self.tableview.delegate = self
        self.tableview.dataSource = self
            self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize){
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            self.preferredContentSize = maxSize;
        }
        else {
            self.preferredContentSize = CGSize(width: 0, height: 500);
        }
    }
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        let defaults = UserDefaults(suiteName: "group.fastwebapp")
        let objects = defaults!.object(forKey: "URLS") as? [String]
        print(objects!)
        if objects != nil{
            self.URLS = objects!.reversed()
            self.tableview.reloadData()
        }
        completionHandler(NCUpdateResult.newData)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return URLS.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UrlsTableViewCell
        let myURLs = URLS[indexPath.row]
        Alamofire.request(myURLs).responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseHTML(html:html,success: {text in
                    cell.label.text = text
                    if cell.label.text == ""{
                        cell.label.text = URL(string: myURLs)?.host
                    }
                })
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URLS[indexPath.row]
        if url.contains("https://") {
            if url.contains("twitter.com/"){
                if url.contains("status"){
                    let twitter = ("twitter://status?id=" + url.substring(from: (url.range(of: "status")?.lowerBound)!).replacingOccurrences(of: "status/", with: ""))
                    extensionContext?.open(URL(string: twitter)!)
                }
            }
        }else{
            extensionContext?.open(URL(string: url)!)
        }
    }
    func parseHTML(html:String,success: (String) -> ()) {
        if html == "Not Found"{
            success("")
        }else if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            success(doc.title!)
        }else{success("")}
    }
    
}

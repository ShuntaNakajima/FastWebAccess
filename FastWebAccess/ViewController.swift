//
//  ViewController.swift
//  FastWebAccess
//
//  Created by nakajimashunta on 2017/03/05.
//  Copyright © 2017年 ShuntaNakajima. All rights reserved.
//

import UIKit
import SDWebImage
import Kanna
import Alamofire
import DZNEmptyDataSet


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource {
    let defaults = UserDefaults(suiteName: "group.fastwebapp")
    @IBOutlet var tableview:UITableView!
    var URLS = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(self.loaddata),
            name:NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
        self.tableview.register(
            UINib(nibName: "ItemTableViewCell", bundle: nil),
            forCellReuseIdentifier: "Cell"
        )
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.emptyDataSetDelegate = self
        self.tableview.emptyDataSetSource = self
        loaddata()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loaddata(){
        let objects = defaults!.object(forKey: "URLS") as? [String]
        if objects != nil{
            print(objects!)
            self.URLS = objects!.reversed()
            if URLS == [] {
               // self.tableview.isHidden = true
            }else{
                self.tableview.isHidden = false
            }
            self.tableview.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return URLS.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        cell.UrlLabel.text = URLS[indexPath.row]
        var url = URL(string:"http://" + (URL(string:URLS[indexPath.row])?.host)! + "/apple-touch-icon.png")
        if URLS[indexPath.row].contains("https"){
            url = URL(string:"https://" + (URL(string:URLS[indexPath.row])?.host)! + "/apple-touch-icon.png")
        }
        let myURLs = URLS[indexPath.row]
        Alamofire.request(myURLs).responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseHTML(html:html,success: {text in
                    cell.TitleLabel.text = text
                    if cell.TitleLabel.text == ""{
                        cell.TitleLabel.text = URL(string: myURLs)?.host
                    }
                    cell.ImageLabel.text = String(cell.TitleLabel.text![cell.TitleLabel.text!.startIndex])
                })
            }
        }
        cell.ImageView.sd_setShowActivityIndicatorView(true)
        cell.ImageView.sd_setIndicatorStyle(.gray)
        cell.ImageView.sd_setImage(with: url!, placeholderImage: UIImage(named: "Noimage.png"), options: SDWebImageOptions.retryFailed, completed: {(image: UIImage?, _: Error?, _: SDImageCacheType!, _: URL?) in
            if image != nil{
            cell.ImageLabel.isHidden = true
            }
            
        })
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URLS[indexPath.row]
        if url.contains("https://") {
            if url.contains("twitter.com/"){
                if url.contains("status"){
                    let twitter = ("twitter://status?id=" + url.substring(from: (url.range(of: "status")?.lowerBound)!).replacingOccurrences(of: "status/", with: ""))
                    UIApplication.shared.openURL(URL(string: twitter)!)
                }
            }else{
            UIApplication.shared.openURL(URL(string: url)!)
            }
        }else{
            UIApplication.shared.openURL(URL(string: url)!)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == UITableViewCellEditingStyle.delete {
            URLS.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            defaults?.set(URLS.reversed() as [String], forKey: "URLS")
            defaults?.synchronize()
        }
    }
    func parseHTML(html:String,success: (String) -> ()) {
        if html == "Not Found"{
            success("")
    }else if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            success(doc.title!)
        }else{success("")}
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No urls"
        let font = UIFont.systemFont(ofSize: 20)
        return NSAttributedString(string: text, attributes: [NSFontAttributeName: font])
    }
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString!{
        let text = "See tutorial"
        let font = UIFont.systemFont(ofSize: 15)
        return NSAttributedString(string: text, attributes: [NSFontAttributeName: font])
    }
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        print("test")
    }
}


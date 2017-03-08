//
//  ViewController.swift
//  FastWebAccess
//
//  Created by nakajimashunta on 2017/03/05.
//  Copyright © 2017年 ShuntaNakajima. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tableview:UITableView!
    var URLS = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.register(
            UINib(nibName: "ItemTableViewCell", bundle: nil),
            forCellReuseIdentifier: "Cell"
        )
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults(suiteName: "group.fastwebapp")
        let objects = defaults!.object(forKey: "URLS") as? [String]
        print(objects!)
        if objects != nil{
            self.URLS = objects!.reversed()
            self.tableview.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            }
        }else{
            UIApplication.shared.openURL(URL(string: url)!)
        }
    }
}


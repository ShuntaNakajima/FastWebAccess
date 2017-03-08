//
//  ShareViewController.swift
//  FastWebAccessSave
//
//  Created by nakajimashunta on 2017/03/07.
//  Copyright © 2017年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Social

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        let inputItem: NSExtensionItem = self.extensionContext?.inputItems[0] as! NSExtensionItem
        let itemProvider = inputItem.attachments![0] as! NSItemProvider
        if (itemProvider.hasItemConformingToTypeIdentifier("public.url")) {
            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: {
                (item, error) in
                let itemNSURL: NSURL = item as! NSURL
                print("URL: " + itemNSURL.absoluteString!)
                let defaults = UserDefaults(suiteName: "group.fastwebapp")
                 if var objects = defaults!.object(forKey: "URLS") as? [String]{
                    print(objects)
                    objects.append(itemNSURL.absoluteString!)
                    defaults?.set(objects, forKey: "URLS")
                    defaults?.synchronize()
                    print("Done!")
                }else{
                    var objects = [String]()
                    objects.append(itemNSURL.absoluteString!)
                    defaults?.set(objects, forKey: "URLS")
                    defaults?.synchronize()
                    print("Done!")
                }
            })
        }
        self.extensionContext!.completeRequest(returningItems:
            [], completionHandler: nil)
    }
}

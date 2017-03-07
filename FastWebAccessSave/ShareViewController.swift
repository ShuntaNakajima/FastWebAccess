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
                print(itemNSURL)
            })
        }
        self.extensionContext!.completeRequest(returningItems:
            [], completionHandler: nil)
    }
}

//
//  ArticleDetailViewController.swift
//  HackerNews
//
//  Created by Anand Nigam on 31/12/18.
//  Copyright © 2018 Anand Nigam. All rights reserved.
//

import UIKit
import WebKit

class ArticleDetailViewController: UIViewController, WKNavigationDelegate {

    var url: String?
    
    @IBOutlet weak var articleWebView: WKWebView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleWebView.navigationDelegate = self

        // Do any additional setup after loading the view.
        print("\n")
        print(url!)
        
        
            articleWebView.load(URLRequest(url: URL(string: url!)!))
        
        
        
    }
    



}

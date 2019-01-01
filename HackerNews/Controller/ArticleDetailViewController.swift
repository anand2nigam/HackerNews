//
//  ArticleDetailViewController.swift
//  HackerNews
//
//  Created by Anand Nigam on 31/12/18.
//  Copyright © 2018 Anand Nigam. All rights reserved.
//

import UIKit
import WebKit

class ArticleDetailViewController: UIViewController, WKNavigationDelegate, UITableViewDelegate, UITableViewDataSource {

    

    var url: String?
    var topComments: [Int]? = [ ]
    var comments: [Comment] = [ ]
    let baseURL = "https://hacker-news.firebaseio.com/v0/item/"
    
    @IBOutlet weak var articleWebView: WKWebView!
    
    @IBOutlet weak var commentTableView: UITableView!
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleWebView.navigationDelegate = self
        
        
        if url != "" {
            
            articleWebView.load(URLRequest(url: URL(string: url!)!))
        } else {
            articleWebView.isHidden = true
        }
        
        
        if topComments != nil {
        getTopComments()
        
        self.commentTableView.register(UITableViewCell.self, forCellReuseIdentifier: "commentCell")
        self.commentTableView.delegate = self
        self.commentTableView.dataSource = self
        
        }
        // Do any additional setup after loading the view.
        
        
        
        
        
    }
    
    // MARK:- TableView Data Source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = commentTableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        
        cell.textLabel?.text = comments[indexPath.row].text + "\n\n By:- \(comments[indexPath.row].by)   At:- \(convert(unixTime: comments[indexPath.row].time))"
        cell.textLabel?.numberOfLines = 0
        
        
        return cell
    }
    

    // MARK:- Networking and JSON Parsing
    
    func getTopComments() {
        
        if let topCommentsID = topComments {
            
            let chunk = topCommentsID.chunked(into: (topComments?.count)!)
            _ = chunk[0].map { self.getCommentData(id: $0) }
        }
        
    }

    func getCommentData(id: Int) {
        
        guard let commentURL = URL(string: "\(baseURL)\(id).json") else { return }
        
        print(commentURL)
        
        URLSession.shared.dataTask(with: commentURL) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let commentResponse = try JSONDecoder().decode(Comment.self, from: data)
                
                print(commentResponse)
                
                self.comments.append(commentResponse)
                
                
                
                DispatchQueue.main.async {
                    self.commentTableView.reloadData()
                }
            }
            
            catch {
                print("error in getting comments")
            }
            
        }.resume()
        
        
    }
    
    // MARK:- Time Conversion
    func convert(unixTime: Int?)-> String {
        
        var localTime = ""
        
        if  let  timeResult = unixTime {
            let date = Date(timeIntervalSince1970: TimeInterval(timeResult))
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
            dateFormatter.timeZone = TimeZone.current
            localTime = dateFormatter.string(from: date)
            
            // print(localTime)
            
            
        }
        
        return localTime
        
    }
    

}



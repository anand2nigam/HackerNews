//
//  NewsFeedTableViewController.swift
//  HackerNews
//
//  Created by Anand Nigam on 30/12/18.
//  Copyright © 2018 Anand Nigam. All rights reserved.
//

import UIKit
import Firebase

class NewsFeedTableViewController: UITableViewController {
    
    let apiBaseURL = "https://hacker-news.firebaseio.com/v0/topstories.json"
    let articleURLBase = "https://hacker-news.firebaseio.com/v0/item/"
    var articles: [Article] = [ ]
    var articleURL: String?
    var commentIDs: [ Int]? = [ ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTopStoriesArray()
        tableView.estimatedRowHeight = 200
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK:- Logging Out
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error in Logging Out")
        }
        
        performSegue(withIdentifier: "backToMainScreen", sender: self)
        
    }
    
    // MARK: - TableView DataSource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articles.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsFeedCell", for: indexPath) as! NewsFeedTableViewCell
        
        cell.accessoryType = .disclosureIndicator
        
        
        cell.mainDetailLabel.text = articles[indexPath.row].title + "\n\(articles[indexPath.row].by!)   \(convert(unixTime: articles[indexPath.row].time!))"
        
        cell.otherDetailLabel.text = " Score:- \(articles[indexPath.row].score!)     Total Comments:- \(articles[indexPath.row].descendants!) "
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        articleURL = articles[indexPath.row].url
        
        commentIDs = articles[indexPath.row].kids
        
        
        
        self.performSegue(withIdentifier: "goToArticleDetail", sender: indexPath.row)
        
    }
    
    // MARK:- Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToArticleDetail" {
            
            let destinationVC = segue.destination as! ArticleDetailViewController
            
            destinationVC.url = articleURL
            destinationVC.topComments = commentIDs
            
            
        }
        
    }
    
    
    // MARK:- Networking and JSON Parsing
    
    private func getTopStoriesArray() {
        guard let url = URL(string: apiBaseURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            if let topArticlesArray = try? JSONDecoder().decode([Int].self, from: data) {
                let chunk = topArticlesArray.chunked(into: 200) // 500 articles are received from API
                _ = chunk[0].map { self.getArticle(id: String($0)) }
            }
            }.resume()
    }
    
    private func getArticle(id: String) {
        let articleId = id
        guard let url = URL(string: "\(articleURLBase)\(articleId).json") else { return }
        // print(url)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let json = try JSONDecoder().decode(Article.self, from: data)
                
                
                
                let author = json.by ?? "Anonymous"
                let comments = json.descendants ?? 0
                let kids: [Int] = json.kids ?? []
                let score = json.score ?? 0
                let type = json.type
                let url = json.url ?? ""
                
                
                
                //Create new article from JSON
                let article = Article(by: author, descendants: comments, id: json.id, kids: kids, score: score , time: json.time , title: json.title, type: type, url: url)
                // Add article to data source for tableview
                self.articles.append(article)
                // print(article)
                // print(self.articles)
                // Jump to main thread and reload tableview
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }
            } catch {
                print("error with getting article")
            }
            }.resume()
    }
    
    // MARK:- Unix Time Conversion
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

// MARK:- Array Chunk Extension

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

//
//  Article.swift
//  HackerNews
//
//  Created by Anand Nigam on 31/12/18.
//  Copyright © 2018 Anand Nigam. All rights reserved.
//

import Foundation


struct Article: Codable {
    let by: String?
    let descendants, id: Int?
    let kids: [Int]?
    let score: Int?
    let time: Int?
    let title, type: String
    let url: String?
}

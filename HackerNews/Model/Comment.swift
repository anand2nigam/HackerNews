//
//  Comment.swift
//  HackerNews
//
//  Created by Anand Nigam on 01/01/19.
//  Copyright © 2019 Anand Nigam. All rights reserved.
//

import Foundation

struct Comment: Codable {
    let by: String
    let id: Int
    let kids: [Int]?
    let parent: Int
    let text: String
    let time: Int
    let type: String
}

//
//  Post.swift
//  AC3.2-Final
//
//  Created by Ana Ma on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

class Post {
    let key: String
    let comment: String
    let userId: String
    
    init(key: String, comment: String, userId: String) {
        self.key = key
        self.comment = comment
        self.userId = userId
    }
    
    var asDictionary: [String: String] {
        return ["userId": userId,
                "comment": comment]
    }
}

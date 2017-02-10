//
//  Repository.swift
//  GithubRepoExample
//
//  Created by Javier Cancio on 16/1/17.
//  Copyright © 2017 Javier Cancio. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

final class Repository: Object {
    
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var organization: String = ""
    dynamic var url: String = ""
    dynamic var avatar: String = ""
    dynamic var stars: Int = 0
    dynamic var forks: Int = 0
    
    // Extra info
    dynamic var desc: String = ""
    dynamic var created: String = ""
    dynamic var updated: String = ""
    dynamic var homepage: String = ""
    dynamic var language: String = ""
    
    dynamic var lastViewed: NSDate? = nil
    

    override static func indexedProperties() -> [String] {
        return ["id"]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Repository: JSONParseable {
  static func fromJSON(_ json: JSON) -> Repository {
    
    let id              = json["id"].intValue
    let name            = json["name"].stringValue
    let organization    = json["owner"]["login"].stringValue
    let url             = json["html_url"].stringValue
    let avatar          = json["owner"]["avatar_url"].stringValue
    let stars           = json["stargazers_count"].intValue
    let forks           = json["forks_count"].intValue
    
    let desc            = json["description"].stringValue
    let created         = json["created_at"].stringValue
    let updated         = json["updated_at"].stringValue
    let homepage        = json["homepage"].stringValue
    let language        = json["language"].stringValue
    
    let repository = Repository(value: [id, name, organization, url, avatar, stars, forks, desc, created, updated, homepage, language, NSDate()])
    
    return repository
  }
}

func == (lhs: Repository, rhs: Repository) -> Bool {
  return lhs.id == rhs.id
}

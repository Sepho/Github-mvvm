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
    
  @objc dynamic var id: Int = 0
  @objc dynamic var name: String = ""
  @objc dynamic var organization: String = ""
  @objc dynamic var url: String = ""
  @objc dynamic var avatar: String = ""
  @objc dynamic var stars: Int = 0
  @objc dynamic var forks: Int = 0
  
  // Extra info
  @objc dynamic var desc: String = ""
  @objc dynamic var created: String = ""
  @objc dynamic var updated: String = ""
  @objc dynamic var homepage: String = ""
  @objc dynamic var language: String = ""
  
  @objc dynamic var lastViewed: NSDate? = nil
    

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

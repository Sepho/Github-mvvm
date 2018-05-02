//
//  JSONParseable.swift
//  GithubRepoExample
//
//  Created by Javier Cancio on 16/1/17.
//  Copyright © 2017 Javier Cancio. All rights reserved.
//

import RxSwift
import SwiftyJSON

protocol JSONParseable {
    static func fromJSON(_: JSON) -> Self
}

//extension JSONParseable {
//  static func fromJSONArray(_ json: [AnyObject]) -> [Self] {
//    return json.map { Self.fromJSON($0) }
//  }
//}

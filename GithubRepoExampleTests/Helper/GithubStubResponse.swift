//
//  GithubStubResponse.swift
//  GithubRepoExample
//
//  Created by Javier Cancio on 21/1/17.
//  Copyright © 2017 Javier Cancio. All rights reserved.
//

import Foundation

class GithubStubResponse {
  static func fakeData() -> Data {
    guard let path = Bundle.main.path(forResource: "fakeResponse", ofType: "json") else {
      fatalError("Invalid path for json file")
    }
    
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
      fatalError("Invalid data from json file")
    }
    return data
  }
}

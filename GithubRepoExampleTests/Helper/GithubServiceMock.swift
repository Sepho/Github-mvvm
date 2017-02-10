//
//  GithubServiceMock.swift
//  GithubRepoExample
//
//  Created by Javier Cancio on 31/1/17.
//  Copyright © 2017 Javier Cancio. All rights reserved.
//

import RxSwift
import SwiftyJSON
import Moya

@testable import GithubRepoExample

class GithubServiceMock: ServiceType {

  var downloadImageCalled     = false
  var searchRepositoryCalled  = false

  let provider: RxMoyaProvider<GitHub>

  init(provider: RxMoyaProvider<GitHub>) {
    self.provider = provider
  }

  func downloadImage(from url: URL?) -> Observable<UIImage?> {
    downloadImageCalled = true
    return Observable.just(UIImage())
  }

  func searchRepository(name: String) -> Observable<[Repository]> {
    searchRepositoryCalled = true
    return provider
      .request(.search(query: name))
      .retry(3)
      .observeOn(MainScheduler.instance)
      .mapJSON()
      .map {
        JSON($0)
      }
      .map { json in
        json["items"].arrayValue.map {
          Repository.fromJSON($0)
        }
      }
      .catchErrorJustReturn([])
  }
}

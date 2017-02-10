//
//  GithubService.swift
//  GithubRepoExample
//
//  Created by Javier Cancio on 22/1/17.
//  Copyright © 2017 Javier Cancio. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON

protocol ServiceType {
  
  var provider: RxMoyaProvider<GitHub> { get }
  
  func downloadImage(from url: URL?)   -> Observable<UIImage?>
  func searchRepository(name: String) -> Observable<[Repository]>
}

class GithubService: ServiceType {
  
  var provider: RxMoyaProvider<GitHub>
  
  init(provider: RxMoyaProvider<GitHub>) {
    self.provider = provider
  }
  
  func downloadImage(from url: URL?) -> Observable<UIImage?> {
    
    guard let url = url else {
      return Observable.just(nil)
    }
    
    let request = URLRequest(url: url)
    
    return URLSession.shared
      .rx
      .data(request: request)
      .map { data in
        return UIImage(data: data)
      }
      .startWith(UIImage())
      .observeOn(MainScheduler.asyncInstance)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .shareReplay(1)
  }
    
  func searchRepository(name: String) -> Observable<[Repository]> {
    if name.isEmpty {
      return Observable.just([])
    }
    
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

//
//  RealmStore.swift
//  GithubRepoExample
//
//  Created by Javier Cancio on 18/1/17.
//  Copyright © 2017 Javier Cancio. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class RealmStore {
  
  private let realm = try! Realm()
  private var notification: NotificationToken? = nil
  
  func save(repository: Repository) {
    try! self.realm.write {
      self.realm.add(repository, update: true)
    }
  }
  
  func update(repository: Repository, lastViewed: NSDate) {
    try! self.realm.write {
      repository.lastViewed = lastViewed
      self.realm.add(repository, update: true)
    }
  }

  func load() -> Observable<[Repository]> {
    return Observable<[Repository]>.deferred {
      return Observable.create { observer in
        
        let repositories = self.realm.objects(Repository.self).sorted(byKeyPath: "lastViewed", ascending: false)      
        
        self.notification = repositories.observe { changes in
          switch changes {
          case .initial(let repos):
            observer.onNext(Array(repos))
          case .update(let repos, _, _, _):
            observer.onNext(Array(repos))
          case .error(let error):
            observer.onError(error)
          }
        }
        
        return Disposables.create()
      }
    }
  }
  
  deinit {
    notification?.invalidate()
  }
  
}

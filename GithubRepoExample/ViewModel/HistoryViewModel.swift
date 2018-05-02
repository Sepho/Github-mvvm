//
//  HistoryViewModel.swift
//  GithubRepoExample
//
//  Created by Javier Cancio on 7/2/17.
//  Copyright © 2017 Javier Cancio. All rights reserved.
//

import Foundation
import RxSwift

class HistoryViewModel {
  
  // Output
  var history: Observable<[HistoryCellViewModel]>?
  
  private let store: RealmStore
  private let disposeBag: DisposeBag
  
  
  init(store: RealmStore) {
    self.store = store
    self.disposeBag = DisposeBag()
    
    history = self.store
      .load()
      .flatMap { repositories -> Observable<[HistoryCellViewModel]> in
        return Observable
          .from(repositories)
          .map { repo in
            return HistoryCellViewModel(repository: repo)
          }
          .toArray()
      }
  }
  
  
}

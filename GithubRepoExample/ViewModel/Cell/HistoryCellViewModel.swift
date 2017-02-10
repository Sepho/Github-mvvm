//
//  HistoryCellViewModel.swift
//  GithubRepoExample
//
//  Created by Javier Cancio on 7/2/17.
//  Copyright © 2017 Javier Cancio. All rights reserved.
//

import Foundation

class HistoryCellViewModel {
  
  var name: String {
    return repository.organization + " / " + repository.name
  }
  
  var lastViewed: String {
    return "Last view: " + parseDate(repository.lastViewed)
  }
  
  private let repository: Repository
  
  init(repository: Repository) {
    self.repository = repository
  }
  
  private func parseDate(_ date: NSDate?) -> String {
    
    guard let date = date else { return "" }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyy - HH:mm:ss"
    
    return dateFormatter.string(from: date as Date)
  }
}

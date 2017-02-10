//
//  DetailViewModelTest.swift
//  GithubRepoExample
//
//  Created by Javier Cancio on 3/2/17.
//  Copyright © 2017 Javier Cancio. All rights reserved.
//

import Quick
import Nimble
import RxBlocking
import RxSwift
import RxCocoa
import RxTest
import SwiftyJSON
import RealmSwift
import Moya

@testable import GithubRepoExample

class DetailViewModelTest: QuickSpec {
  
  override func spec() {
    var sut: DetailViewModel!
    var store: RealmStore!
    var repo: Repository!
    
    var mockService: GithubServiceMock!
    
    beforeEach {
      Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
      let data = GithubStubResponse.fakeData()
      let json = JSON(data)
      repo = Repository.fromJSON(json["items"].arrayValue.first!)
      mockService = GithubServiceMock(provider: RxMoyaProvider<GitHub>(stubClosure: MoyaProvider.immediatelyStub))
      store = RealmStore()
      sut = DetailViewModel(service: mockService, store: store, repository: repo)
    }
    
    afterEach {
      store = nil
      repo = nil
      mockService = nil
      sut = nil
    }
    
    it("returns repository name") {
      expect(sut.repositoryName) == "dtrupenn / Tetris"
    }
    
    it("returns repository description") {
      expect(sut.repositoryDescription) == "A C implementation of Tetris using Pennsim through LC4"
    }
    
    it("returns repository stars") {
      expect(sut.repositoryStars) == "Stars: 1"
    }
    
    it("returns repository forks") {
      expect(sut.repositoryForks) == "Forks: 0"
    }

    it("returns repository created date") {
      expect(sut.repositoryCreated) == "Created 01/01/2012"
    }
    
    it("returns repository updated date") {
      expect(sut.repositoryUpdated) == "Updated 05/01/2013"
    }
    
    it("returns repository language") {
      expect(sut.repositoryLanguage) == "Language: Assembly"
    }
    
    it("returns repository homepage") {
      expect(sut.repositoryHomepage) == "Not available"
    }
    
    it("adds current date as lastViewed property") {
      let realm = try! Realm()
      
      expect(realm.object(ofType: Repository.self, forPrimaryKey: repo.id)?.lastViewed).to(beCloseTo(NSDate(), within: 1000))
    }
    
    it("adds current repository to realm") {
      let realm = try! Realm()
      
      expect(realm.objects(Repository.self).count).to(equal(1))
    }
    
    context("given repository avatar url") {
      
      var scheduler: TestScheduler!
      var disposeBag: DisposeBag!
      
      beforeEach {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
      }
      
      afterEach {
        scheduler = nil
        disposeBag = nil
      }
      
      it("call download image method") {
        let observer = scheduler.createObserver((UIImage?.self)!)
        
        scheduler.scheduleAt(100) {
          sut.repositoryImage.subscribe(observer).addDisposableTo(disposeBag)
        }
        
        scheduler.start()
        
        expect(mockService.downloadImageCalled).toEventually(beTrue())
        expect(observer.events.count) == 2 // onNext and onComplete
      }
    }
  }
}

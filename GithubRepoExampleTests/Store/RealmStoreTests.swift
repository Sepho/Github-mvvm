//
//  RealmStoreTests.swift
//  GithubRepoExample
//
//  Created by Javier Cancio on 18/1/17.
//  Copyright © 2017 Javier Cancio. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import RealmSwift
import RxTest

@testable import GithubRepoExample

class RealmStoreTests: QuickSpec {
  override func spec() {
    describe("A Realm DB Store") {
      
      var disposableBag:  DisposeBag!
      
      beforeEach {
        disposableBag   = DisposeBag()
      }
      
      context("given repository object") {
        
        var repository:     Repository!
        
        beforeEach {
          repository      = Repository()
          repository.id   = 1234
          
          Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        }
        
        it("stores repository object on Realm") {
          let store = RealmStore()
          _ = store.save(repository: repository)
          
          let realm = try! Realm()
          expect(realm.objects(Repository.self).count).to(equal(1))
        }
        
        it("dont store the same repository twice") {
          let realm = try! Realm()
          let store = RealmStore()        
          
          store.save(repository: repository)
          store.save(repository: repository)
          
          expect(realm.objects(Repository.self).count).to(equal(1))
        }
        
        it("returns all stored repositories") {
          let store = RealmStore()
          let realm = try! Realm()
          
          let sampleRepository = Repository()
          sampleRepository.id = 1234
          
          let anotherRepository = Repository()
          anotherRepository.id = 5678
          
          try! realm.write {
            realm.add([sampleRepository, anotherRepository])
          }

          store
            .load()
            .subscribe(onNext: { repositories in
              expect(repositories.count).to(equal(2))
            })
            .addDisposableTo(disposableBag)
        }
        
        it("updates stored repository with new data") {
          let realm = try! Realm()
          let store = RealmStore()
          
          repository.name = "Foo"
          store.save(repository: repository)
          
          expect(realm.object(ofType: Repository.self, forPrimaryKey: repository.id)?.name).to(equal("Foo"))
          
          let anotherRepository = Repository()
          anotherRepository.id    = repository.id // Same id as previous repository so it should be updated
          anotherRepository.name  = "Bar"
          
          store.save(repository: anotherRepository)
          
          expect(realm.object(ofType: Repository.self, forPrimaryKey: repository.id)?.name).to(equal("Bar"))
        }
        
      }
    }
  }
}

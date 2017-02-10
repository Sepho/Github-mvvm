//
//  SearchViewModelTest.swift
//  GithubRepoExample
//
//  Created by Javier Cancio on 31/1/17.
//  Copyright © 2017 Javier Cancio. All rights reserved.
//

import Quick
import Nimble
import RxBlocking
import RxSwift
import RxCocoa
import RxTest
import Moya

@testable import GithubRepoExample

class SearchViewModelTest: QuickSpec {

  override func spec() {
    var sut: SearchViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var mockService: GithubServiceMock!

    beforeEach {
      scheduler   = TestScheduler(initialClock: 0)
      mockService = GithubServiceMock(provider: RxMoyaProvider<GitHub>(stubClosure: MoyaProvider.immediatelyStub))
      sut         = SearchViewModel(service: mockService)
      disposeBag  = DisposeBag()
    }

    afterEach {
      scheduler   = nil
      disposeBag  = nil
      sut         = nil
      mockService = nil
    }

    it("should start with empty data") {
      let observer = scheduler.createObserver([RepositoryCellViewModel].self)


      scheduler.scheduleAt(100) {
        sut.repositories.asObservable().subscribe(observer).addDisposableTo(disposeBag)
      }

      scheduler.start()

      let result = observer.events.first
        .map { event in
          event.value.element!
      }

      expect(result).to(beEmpty())
    }

    it("should perform query on text input") {
      let observer = scheduler.createObserver([RepositoryCellViewModel].self)

      scheduler.scheduleAt(100) {
        sut.repositories.asObservable().subscribe(observer).addDisposableTo(disposeBag)
      }

      scheduler.scheduleAt(200) {
        sut.searchQuery.value = "a"
      }

      scheduler.start()

      expect(mockService.searchRepositoryCalled).toEventually(beTrue())
    }
    
    it("should emit an empty array after remove query text") {
      let observer = scheduler.createObserver([RepositoryCellViewModel].self)
      
      scheduler.scheduleAt(100) {
        sut.repositories.asObservable().subscribe(observer).addDisposableTo(disposeBag)
      }
      
      scheduler.scheduleAt(200) {
        sut.searchQuery.value = "a"
      }
      
      scheduler.scheduleAt(300) {
        sut.searchQuery.value = ""
      }
      
      scheduler.start()
      
      expect(observer.events.count) == 3
      
      let lastResult = observer.events.last
        .map { event in
          event.value.element!
      }
      
      expect(lastResult).to(beEmpty())
    }

    it("should create cell view model on server response") {
      let observer = scheduler.createObserver([RepositoryCellViewModel].self)

      scheduler.scheduleAt(100) {
        sut.repositories.asObservable().subscribe(observer).addDisposableTo(disposeBag)
      }
      
      scheduler.scheduleAt(200) {
        sut.searchQuery.value = "a"
      }
      
      scheduler.start()

      let result = observer.events.last
        .map { event in
          event.value.element!.count
      }
      
      expect(result) == 1
    }

    it("show loading when request starts and hides when finish") {
      let observer = scheduler.createObserver(Bool.self)
      
      scheduler.scheduleAt(100) {
        sut.showLoading.asObservable().subscribe(observer).addDisposableTo(disposeBag)
        sut.repositories.subscribe().addDisposableTo(disposeBag)
      }
      
      scheduler.scheduleAt(200) {
        sut.searchQuery.value = "a"
      }
      
      scheduler.start()
      
      let results = observer.events
        .map { event in
          event.value.element!
      }
      
      expect(results) == [false, true, false]
    }

    it("returns detail view model when item clicked") {
      let observer = scheduler.createObserver(DetailViewModel.self)

      scheduler.scheduleAt(100) {
        sut.repositories.asObservable().subscribe().addDisposableTo(disposeBag)
      }

      scheduler.scheduleAt(200) {
        sut.searchQuery.value = "a"
      }

      scheduler.scheduleAt(300) {
        sut.selectedRepo.subscribe(observer).addDisposableTo(disposeBag)
      }

      scheduler.scheduleAt(400) {
        sut.selectedIndex.onNext(IndexPath(row: 0, section: 0))
      }

      scheduler.start()

      let result = observer.events.last
        .map { event in
          event.value.element!
        }

      expect(result).toNot(beNil())
    }    
  }
}

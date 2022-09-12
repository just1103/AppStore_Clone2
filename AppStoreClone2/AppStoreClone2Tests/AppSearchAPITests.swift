//
//  AppSearchAPITests.swift
//  AppStoreCloneTests
//
//  Created by Hyoju Son on 2022/09/01.
//

import XCTest
import RxSwift
@testable import AppStoreClone2

class AppSearchAPITests: XCTestCase {
    var sut: NetworkProvider!
    var disposeBag: DisposeBag!
    let idusSearchText = "핸드메이드"
    let kakaoTalkSearchText = "카카오톡"
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkProvider()
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        disposeBag = nil
    }
    
    func test_Idus_AppID로_AppSearchAPI가_정상작동_하는지() {
        let expectation = XCTestExpectation(description: "AppSearchAPI 비동기 테스트")

        let observable = sut.fetchData(
            api: ItunesAPI.AppSearch(searchText: idusSearchText),
            decodingType: SearchResultDTO.self
        )
        
        observable.subscribe(onNext: { searchResultDTO in
            XCTAssertNotNil(searchResultDTO)
            XCTAssertEqual(searchResultDTO.resultCount, 30)

            let appItemDTO = searchResultDTO.results.first!
            let appItem = AppItem.convert(appItemDTO: appItemDTO)
            XCTAssertEqual(appItem.trackName, "아이디어스(idus)")
            XCTAssertEqual(appItem.artistName, "Backpackr Inc.")

            expectation.fulfill()
        }, onError: { _ in
            XCTFail()
        })
        .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_KakaoTalk_AppID로_AppSearchAPI가_정상작동_하는지() {
        let expectation = XCTestExpectation(description: "AppSearchAPI 비동기 테스트")

        let observable = sut.fetchData(
            api: ItunesAPI.AppSearch(searchText: kakaoTalkSearchText),
            decodingType: SearchResultDTO.self
        )
        
        observable.subscribe(onNext: { searchResultDTO in
            XCTAssertNotNil(searchResultDTO)
            XCTAssertEqual(searchResultDTO.resultCount, 30)

            let appItemDTO = searchResultDTO.results.first!
            let appItem = AppItem.convert(appItemDTO: appItemDTO)
            XCTAssertEqual(appItem.trackName, "카카오톡 KakaoTalk")
            XCTAssertEqual(appItem.artistName, "Kakao Corp.")

            expectation.fulfill()
        }, onError: { _ in
            XCTFail()
        })
        .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 10.0)
    }
    
}

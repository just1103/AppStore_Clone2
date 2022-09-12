//
//  NetworkProviderTests.swift
//  AppStoreCloneTests
//
//  Created by Hyoju Son on 2022/08/07.
//

import XCTest
import RxSwift
@testable import AppStoreClone2

class AppLookupAPITests: XCTestCase {
    
    var sut: NetworkProvider!
    var disposeBag: DisposeBag!
    let idusAppID = "872469884"
    let kakaoTalkAppID = "362057947"

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
    
    func test_Idus_AppID로_AppLookupAPI가_정상작동_하는지() {
        // URL : http://itunes.apple.com/lookup?media=software&country=kr&id=872469884
        let expectation = XCTestExpectation(description: "AppLookupAPI 비동기 테스트")

        let observable = sut.fetchData(
            api: ItunesAPI.AppLookup(appID: idusAppID),
            decodingType: SearchResultDTO.self
        )
        
        observable
            .subscribe(onNext: { searchResultDTO in
                XCTAssertNotNil(searchResultDTO)
                XCTAssertEqual(searchResultDTO.resultCount, 1)
                
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
    
    func test_KakaoTalk_AppID로_AppLookupAPI가_정상작동_하는지() {
        // URL : http://itunes.apple.com/lookup?country=kr&media=software&id=362057947
        let expectation = XCTestExpectation(description: "AppLookupAPI 비동기 테스트")

        let observable = sut.fetchData(
            api: ItunesAPI.AppLookup(appID: kakaoTalkAppID),
            decodingType: SearchResultDTO.self
        )

        observable
            .subscribe(onNext: { searchResultDTO in
            XCTAssertNotNil(searchResultDTO)
            XCTAssertEqual(searchResultDTO.resultCount, 1)

            let appItemDTO = searchResultDTO.results.first!
            let appItem = AppItem.convert(appItemDTO: appItemDTO)
                XCTAssertEqual(appItem.trackName, "카카오톡 KakaoTalk")
                XCTAssertEqual(appItem.artistName, "Kakao Corp.")

            expectation.fulfill()
        })
        .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 10.0)
    }

}

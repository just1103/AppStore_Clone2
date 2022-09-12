//
//  LookupViewModel.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/08.
//

import RxSwift
import RxCocoa
import Foundation

final class LookupViewModel: ViewModelProtocol {
    
    // MARK: - Nested Types
    
    struct Input {
        let searchTextDidReturn: Observable<String>
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let navigationTitleText: Driver<String>
        let backButtonTitleText: Driver<String>
        let searchTextFieldPlaceHolderText: Driver<String>
//        let descriptionLabelText: Driver<String>
        let appItems: Driver<[AppItem]>
    }
    
    // MARK: - Properties
    
    private weak var coordinator: LookupCoordinator!
    private let disposeBag = DisposeBag()
    private let currentSearchText = BehaviorRelay<String>(value: "")
    private let descriptionLabelText = BehaviorRelay<String>(value: "")
    
    // MARK: - Initializers
    
    init(coordinator: LookupCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    
    func transform(_ input: Input) -> Output {
        onSearchTextDidReturn(input.searchTextDidReturn)
//        validateAPIResponse()
        onViewWillAppear(input.viewWillAppear)
        
        return Output(
            navigationTitleText: navigationTitleText(),
            backButtonTitleText: backButtonTitleText(),
            searchTextFieldPlaceHolderText: searchTextFieldPlaceHolderText(),
//            descriptionLabelText: descriptionLabelText.asDriver(onErrorJustReturn: ""),
            appItems: fetchAppItems()
        )
    }
    
    private func onSearchTextDidReturn(_ input: Observable<String>) {
        input
            .bind(to: currentSearchText) // ???: 여러 곳에서 사용하려면 불가피한 binding인가?
            .disposed(by: disposeBag)
    }
    
//    private func validateAPIResponse() {
//        // TODO: searchText가 넘어올 때마다 fetchData를 시도하고 결과를 descriptionLabelText (BehaviorRelay)에다가 보냄
//        // FIXME: 유효하지 않은 AppID를 입력했을 때 desriptionText가 제대로 전달되지 않음
//        currentSearchText
//            .distinctUntilChanged()
//            .filter { $0.isEmpty == false }
//            .debounce(.milliseconds(600), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .default))
//            .subscribe(onNext: { [weak self] searchText in
//                guard let self = self else { return }
//
//                _ = self.fetchData(with: searchText)
//                    .map { searchResultDTO in
//                        guard
//                            searchResultDTO.resultCount == 1,
//                            let appItemDTO = searchResultDTO.results.first
//                        else {
//                            self.descriptionLabelText.accept(Text.descriptionLabelTextIfRequestFail)
//                            return
//                        }
//
//                        let appItem = AppItem.convert(appItemDTO: appItemDTO)
//                        DispatchQueue.main.async { [weak self] in
//    //                        self.coordinator.showDetailPage(with: appItem)
//                        }
//
//                        self.descriptionLabelText.accept("")
//                    }
//            })
//            .disposed(by: disposeBag)
//    }
    
    private func onViewWillAppear(_ input: Observable<Void>) {
        // TODO: "" 정상 출력되는지 확인
        input
            .map { "" }
            .bind(to: descriptionLabelText)  // ???: main 스레드에서 안받아와도 될것 같은데.. 써도되나
            .disposed(by: disposeBag)
        
//            .subscribe(onNext: {
//                print("WillAppear!!!")
//                searchTextFieldPlaceHolderText.accept("")
//                // output의 descriptionLabelText에 onNext 하려면 어떻게?
//                // descriptionLabelText를 behaviorRelay로 갖고 있어야하나?
//            })
//            .disposed(by: disposeBag)
    }
    
    private func navigationTitleText() -> Driver<String> {
        return Observable.just(Text.navigationTitle)
            .asDriver(onErrorJustReturn: "")
    }
    
    private func backButtonTitleText() -> Driver<String> {
        return Observable.just(Text.backButtonTitle)
            .asDriver(onErrorJustReturn: "")
    }
    
    private func searchTextFieldPlaceHolderText() -> Driver<String> {
        return Observable.just(Text.searchTextFieldPlaceHolder)
            .asDriver(onErrorJustReturn: "")
    }
    
    private func fetchAppItems() -> Driver<[AppItem]> {
        return currentSearchText
            .distinctUntilChanged()
            .filter { $0.isEmpty == false }
            .debounce(.milliseconds(300), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .default))
            .flatMap { [weak self] searchText -> Observable<[AppItem]> in
                guard let self = self else {
                    return Observable.just([])
                }
                
                return self.fetchData(with: searchText)
                    .map { searchResultDTO -> [AppItem] in
                        let appItems = searchResultDTO.results.map { appItemDTO in
                            AppItem.convert(appItemDTO)
                        }
                        return appItems
                    }
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    private func fetchData(with searchText: String) -> Observable<SearchResultDTO> {
        // TODO: NetworkProvider가 처리하도록 역할 재분배
        let isNumber = searchText.allSatisfy { $0.isNumber }
        
        // TODO: 추상화
        if isNumber {
            return NetworkProvider().fetchData(
                api: ItunesAPI.AppLookup(appID: searchText),
                decodingType: SearchResultDTO.self
            )
        } else {
            return NetworkProvider().fetchData(
                api: ItunesAPI.AppSearch(searchText: searchText),
                decodingType: SearchResultDTO.self
            )
        }
    }
    
}

// MARK: - NameSpaces

extension LookupViewModel {
    
    private enum Text {
        static let navigationTitle = "검색"
        static let backButtonTitle = "검색"
        static let searchTextFieldPlaceHolder = "앱 ID를 입력해주세요."
        static let descriptionLabelTextIfRequestFail = "앱 ID를 다시 확인해주세요."
        static let emptyString = ""
    }
    
}

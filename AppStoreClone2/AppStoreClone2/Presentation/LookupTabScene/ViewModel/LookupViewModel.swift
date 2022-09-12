//
//  LookupViewModel.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/08.
//

import RxSwift
import RxCocoa
import UIKit

final class LookupViewModel: ViewModelProtocol {
    
    // MARK: - Nested Types
    
    struct Input {
        let searchTextDidReturn: Observable<String>
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let tabBarItemTitleText: Driver<String>
        let tabBarItemImage: Driver<UIImage>
        let tabBarItemSelectedImage: Driver<UIImage>
        let navigationTitleText: Driver<String>
        let backButtonTitleText: Driver<String>
        let searchTextFieldPlaceHolderText: Driver<String>
        let appItems: Driver<[AppItem]>
    }
    
    // MARK: - Properties
    
    private weak var coordinator: LookupCoordinator!
    private let disposeBag = DisposeBag()
    private let currentSearchText = BehaviorRelay<String>(value: "")
    
    // MARK: - Initializers
    
    init(coordinator: LookupCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    
    func transform(_ input: Input) -> Output {
        onSearchTextDidReturn(input.searchTextDidReturn)
        
        return Output(
            tabBarItemTitleText: tabBarItemTitleText(),
            tabBarItemImage: tabBarItemImage(),
            tabBarItemSelectedImage: tabBarItemSelectedImage(),
            navigationTitleText: navigationTitleText(),
            backButtonTitleText: backButtonTitleText(),
            searchTextFieldPlaceHolderText: searchTextFieldPlaceHolderText(),
            appItems: fetchAppItems()
        )
    }
    
    private func onSearchTextDidReturn(_ input: Observable<String>) {
        input
        // ???: main 스레드에서 안받아와도 될것 같은데.. bind 써도되나
            .bind(to: currentSearchText) // ???: 여러 곳에서 사용하려면 불가피한 binding인가?
            .disposed(by: disposeBag)
    }
    
    private func tabBarItemTitleText() -> Driver<String> {
        return Observable.just(Text.tabBarItemTitleText)
            .asDriver(onErrorJustReturn: "")
    }
    
    private func tabBarItemImage() -> Driver<UIImage> {
        return Observable.just(UIImage(systemName: "magnifyingglass")!)  // TODO: 강제언래핑 개선
            .asDriver(onErrorJustReturn: UIImage(systemName: "magnifyingglass")!)
    }
    
    private func tabBarItemSelectedImage() -> Driver<UIImage> {
        return Observable.just(UIImage(systemName: "magnifyingglass")!)  // TODO: 강제언래핑 개선
            .asDriver(onErrorJustReturn: UIImage(systemName: "magnifyingglass")!)
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
        static let tabBarItemTitleText = "검색"
        static let navigationTitle = "검색"
        static let backButtonTitle = "검색"
        static let searchTextFieldPlaceHolder = "앱 ID를 입력해주세요."
        static let descriptionLabelTextIfRequestFail = "앱 ID를 다시 확인해주세요."
        static let emptyString = ""
    }
    
}

// MARK: - ImageError

extension LookupViewModel {
    
    private enum ImageError: Error {
        case systemImageNotFound
    }
}

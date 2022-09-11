//
//  LookupViewModel.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/08.
//

import RxSwift
import RxCocoa
import Foundation

final class LookupViewModel { //: ViewModelProtocol {
    
    // MARK: - Nested Types
    
    struct Input {
        let searchTextDidReturn: Observable<String>
    }
    
    struct Output {
        let descriptionLabelText: Driver<String>
    }
    
    // MARK: - Properties
    private weak var coordinator: LookupCoordinator!
    private let disposeBag = DisposeBag()
    
    // ???: 이거 왜 필요하지? Input -> Ouput에 바로 연결시키면 안되나 (inout 매개변수 개념처럼 보이는데...)
    // 추측: Input-Output 1:1 관계가 아니여서 좀더 유연하게 활용가능해서
    private let currentSearchText = BehaviorRelay<String>(value: "")
    
    // MARK: - Initializers
    init(coordinator: LookupCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
//    func transform(_ input: Input) -> Output {
//        let isAPIResponseValid = configureSearchTextDidReturnSubscriber(for: input.searchTextDidReturn)
//
//        let output = Output(isAPIResponseValid: isAPIResponseValid)
//
//        return output
//    }

    func transform(_ input: Input) -> Output {
        onSearchTextDidReturn(input.searchTextDidReturn)

        return Output(descriptionLabelText: isAPIResponseValid())
    }
    
    private func onSearchTextDidReturn(_ input: Observable<String>) {
        input
            .bind(to: currentSearchText)
            .disposed(by: disposeBag)
    }
    
    private func isAPIResponseValid() -> Driver<String> {
        return currentSearchText
            .filter { $0.isEmpty == false }
            .map { [weak self] searchText -> String in
                guard let self = self else {
                    return Text.descriptionLabelTextIfRequestFail
                }
                return ""

                // 그냥 String만 와야하는데 map을 쓰니까 Observable<String>이 나오는 문제
                // flatMap을 써도 반환값을 Observable로 예상함
                // fetchData 반환값을 다른걸로 받아야하나?
                return self.fetchData(with: searchText).map { searchResultDTO -> String in
                    guard
                        let self = self,
                        searchResultDTO.resultCount == 1,
                        let appItemDTO = searchResultDTO.results.first
                    else {
                        return Text.descriptionLabelTextIfRequestFail
                    }

                    let appItem = AppItem.convert(appItemDTO: appItemDTO)
                    DispatchQueue.main.async { [weak self] in
//                        self.coordinator.showDetailPage(with: appItem)
                    }

                    return ""
                }
                
            }
            .asDriver(onErrorJustReturn: Text.descriptionLabelTextIfRequestFail)
    }
    
//    private func configureSearchTextDidReturnSubscriber(
//        for inputPublisher: AnyPublisher<String, Never>
//    ) -> AnyPublisher<Bool, Never> {
//        return inputPublisher
//            .filter { $0.isEmpty == false }
//            .flatMap { [weak self] searchText -> AnyPublisher<Bool, Never> in
//                guard let self = self else { return Just(false).eraseToAnyPublisher() }
//
//                return self.fetchData(with: searchText)
//                    .map { searchResultDTO -> Bool in
//                        guard
//                            searchResultDTO.resultCount == 1,
//                            let appItemDTO = searchResultDTO.results.first
//                        else {
//                            return false
//                        }
//
//                        let appItem = AppItem.convert(appItemDTO: appItemDTO)
//
//                        DispatchQueue.main.async { [weak self] in
//                            self?.coordinator.showDetailPage(with: appItem)
//                        }
//
//                        return true
//                    }
//                    .replaceError(with: false)
//                    .eraseToAnyPublisher()
//
//            }
//            .eraseToAnyPublisher()
//    }
    
    private func fetchData(with searchText: String) -> Observable<SearchResultDTO> {
        return NetworkProvider().fetchData(
            api: ItunesAPI.AppLookup(appID: searchText),
            decodingType: SearchResultDTO.self
        )
    }
}

// MARK: - NameSpaces
extension LookupViewModel {
    private enum Text {
        static let navigationTitle = "검색"
        static let searchTextFieldPlaceHolder = "앱 ID를 입력해주세요."
        static let descriptionLabelTextIfRequestFail = "앱 ID를 다시 확인해주세요."
        static let emptyString = ""
    }
    
    private enum Design {
        static let backButtonTitle = "검색"
    }
}

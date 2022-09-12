//
//  MainTabBarViewModel.swift
//  AppStoreClone2
//
//  Created by Hyoju Son on 2022/09/13.
//

import RxSwift
import RxCocoa
import UIKit

final class MainTabBarViewModel {
    
    // MARK: - Nested Types

    enum TabBarItemKind: Int {
        case lookup, favorite
        
        var navigationTitle: String {
            switch self {
            case .lookup:
                return "검색"
            case .favorite:
                return "즐겨찾기"
            }
        }
    }
    
    struct Input {
        let tabBarIndexDidSelect: Observable<Index>
    }
    
    struct Output {
        let navigationTitleText: Driver<String>
        let tabBarTintColor: Driver<UIColor>
        let tabBarUnselectedItemTintColor: Driver<UIColor>
//        let tabBarPages: Driver<[UINavigationController]> // ViewControllers에 할당
    }
    
    // MARK: - Properties
    
    private weak var coordinator: MainTabBarCoordinator!
    private let disposeBag = DisposeBag()
    private let selectedTabBar = BehaviorRelay(value: TabBarItemKind.lookup)
//    private let selectedIndex = BehaviorRelay(value: 0)
    
    typealias Index = Int
    
    // MARK: - Initializers
    
    init(coordinator: MainTabBarCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    
    func transform(_ input: Input) -> Output {
        onTabBarItemDidSelected(input.tabBarIndexDidSelect)
        
        return Output(
            navigationTitleText: navigationTitleText(),
            tabBarTintColor: tabBarTintColor(),
            tabBarUnselectedItemTintColor: tabBarUnselectedItemTintColor()
//            tabBarPages: <#T##Driver<[UINavigationController]>#>
        )
    }
    
    private func onTabBarItemDidSelected(_ input: Observable<Index>) {
        input
            .compactMap { TabBarItemKind(rawValue: $0) }
            .bind(to: selectedTabBar)
            .disposed(by: disposeBag)
    }
    
    private func navigationTitleText() -> Driver<String> {
        selectedTabBar
            .distinctUntilChanged()
            .map { $0.navigationTitle }
            .asDriver(onErrorJustReturn: TabBarItemKind.lookup.navigationTitle)
    }
    
    private func tabBarTintColor() -> Driver<UIColor> {
        return Observable.just(UIColor.systemBlue)
            .asDriver(onErrorJustReturn: UIColor.systemBlue)
    }
    
    private func tabBarUnselectedItemTintColor() -> Driver<UIColor> {
        return Observable.just(UIColor.lightGray)
            .asDriver(onErrorJustReturn: UIColor.lightGray)
    }
    
//    private func tabBarPages() -> Driver<[UINavigationController]> {
//
//    }
    
}

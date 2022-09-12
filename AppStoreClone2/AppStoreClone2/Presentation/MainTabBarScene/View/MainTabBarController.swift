//
//  MainTabBarController.swift
//  AppStoreClone2
//
//  Created by Hyoju Son on 2022/09/13.
//

import RxSwift
import RxCocoa
import RxRelay
import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private var viewModel: MainTabBarViewModel!
    private let disposeBag = DisposeBag()
    private var pages: [UINavigationController]!
    private let tabBarIndexDidSelect = BehaviorRelay(value: 0)
    
    // MARK: - Initializers
    
    init(viewModel: MainTabBarViewModel, pages: [UINavigationController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.pages = pages
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ???: UITabBarController init의 side-effect로 인해 viewDidLoad 대신 해당 위치에 배치함
        configureNavigationBar()
        configureTabBar()
        bind()
    }
    
    // MARK: - Methods
    
    private func configureNavigationBar() {
        navigationItem.hidesBackButton = true
    }

    private func configureTabBar() {
        viewControllers = pages
    }

}

// MARK: - TabBarController Delegate

extension MainTabBarController: UITabBarControllerDelegate {

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let selectedIndex = tabBar.items?.firstIndex(of: item) else { return }
        tabBarIndexDidSelect.accept(selectedIndex)
    }

}

// MARK: - Rx Binding Methods

extension MainTabBarController {
    
    private func bind() {
        let input = MainTabBarViewModel.Input(
            tabBarIndexDidSelect: tabBarIndexDidSelect.asObservable()
            // TODO: TabBar 관련 Rx 검색
//            tabBarIndexDidSelect: tabBarController!.rx.selectedIndex.val
//            tabBarIndexDidSelect: tabBar.rx.didSelectItem.asObservable()
//                self.rx.selectedIndex
        )
        
        
        
        let output = viewModel.transform(input)
        
//        output.tabBarPages
//            .drive(viewControllers)
//            .dispose(by: disposeBag)
        
        output.navigationTitleText
            .drive(self.navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
}

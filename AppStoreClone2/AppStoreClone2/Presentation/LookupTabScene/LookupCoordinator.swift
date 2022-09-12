//
//  LookupCoordinator.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/08.
//

import UIKit

final class LookupCoordinator: CoordinatorProtocol {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController? = UINavigationController()
    var childCoordinators = [CoordinatorProtocol]()
    var type: CoordinatorType = .lookup
    
    // MARK: - Methods
    func start() {}
    
    func createViewController() -> UINavigationController {
        let lookupViewModel = LookupViewModel(coordinator: self)
        let lookupViewController = LookupViewController(viewModel: lookupViewModel)
        navigationController = UINavigationController(rootViewController: lookupViewController)
//        navigationController?.navigationBar.isHidden = true
        
        guard let navigationController = navigationController else {
            return UINavigationController()
        }

        return navigationController
    }
    
//    private func showLookupPage() {
//        guard let navigationController = navigationController else { return }
//        let lookupViewModel = LookupViewModel(coordinator: self)
//        let lookupViewController = LookupViewController(viewModel: lookupViewModel)
//  
//        navigationController.pushViewController(lookupViewController, animated: false)
//    }
        
//    func showDetailPage(with appItem: AppItem) {
//        guard let navigationController = navigationController else { return }
//        let detailCoordinator = DetailCoordinator(navigationController: navigationController)
//        childCoordinators.append(detailCoordinator)
//        detailCoordinator.delegate = self
//        detailCoordinator.start(with: appItem)
//    }
}

// MARK: - DetailCoordinator Delegete
//extension LookupCoordinator: DetailCoordinatorDelegete {
//    func removeFromChildCoordinators(coordinator: CoordinatorProtocol) {
//        let updatedChildCoordinators = childCoordinators.filter { $0 !== coordinator }
//        childCoordinators = updatedChildCoordinators
//    }
//}

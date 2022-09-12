import RxSwift
import UIKit

final class MainTabBarCoordinator: CoordinatorProtocol {
    
    // MARK: - Properties
    
    var childCoordinators = [CoordinatorProtocol]()
    var navigationController: UINavigationController?
    var type: CoordinatorType = .tabBar
    private var mainTabBarController: MainTabBarController!
    
    // MARK: - Initializers
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
//        navigationController.navigationBar.isTranslucent = true
    }
    
    // MARK: - Methods
    
    func start() {
        showMainTabBarScene()
    }
    
    func popCurrentPage() {
        navigationController?.popViewController(animated: false)
    }
    
//    func hideNavigationBarAndTabBar() {
//        navigationController?.navigationBar.isHidden = true
//        mainTabBarController.tabBar.isHidden = true
//    }
//
//    func showNavigationBarAndTabBar() {
//        navigationController?.navigationBar.isHidden = false
//        mainTabBarController.tabBar.isHidden = false
//    }
    
    private func showMainTabBarScene() {
        let lookupCoordinator = LookupCoordinator()
//        let favoriteCoordinator = FavoriteCoordinator()
        
        childCoordinators.append(lookupCoordinator)
//        childCoordinators.append(favoriteCoordinator)
        
        // ???: ViewController 생성하는 역할을 누가 하는게 나을까?
        let lookupViewController = lookupCoordinator.createViewController()
//        let favoriteViewController = favoriteCoordinator.createViewController()
        
        let mainTabBarViewModel = MainTabBarViewModel(coordinator: self)
        mainTabBarController = MainTabBarController(
            viewModel: mainTabBarViewModel,
            pages: [lookupViewController]
//            pages: [lookupViewController, favoriteViewController]
        )

        navigationController?.viewControllers = [mainTabBarController]
    }
    
}

//func removeFromChildCoordinators(coordinator: CoordinatorProtocol) {
//    let updatedChildCoordinators = childCoordinators.filter { $0 !== coordinator }
//    childCoordinators = updatedChildCoordinators
//}

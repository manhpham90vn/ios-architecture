//
//  MainRouter.swift
//  VIPPER
//
//  Created by Manh Pham on 3/5/21.
//

import UIKit

protocol MainRouterInterface {
    func navigationToDetailScreen(item: Event)
    func navigationToLoginScreen()
}

final class MainRouter: MainRouterInterface, Router {

    unowned let viewController: MainViewController

    required init(viewController: MainViewController) {
        self.viewController = viewController
        viewController.presenter = MainPresenter(view: viewController,
                                                 router: self,
                                                 interactor: MainInteractor())
    }

    deinit {
        LogInfo("\(type(of: self)) Deinit")
    }

    func navigationToDetailScreen(item: Event) {
        let vc = AppScenes.detail(event: item).viewController
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigationToLoginScreen() {
        UIWindow.shared?.rootViewController = UINavigationController(rootViewController: AppScenes.login.viewController)
    }

}

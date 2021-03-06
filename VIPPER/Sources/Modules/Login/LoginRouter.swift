//
//  LoginRouter.swift
//  VIPPER
//
//  Created by Manh Pham on 3/4/21.
//

import UIKit

protocol LoginRouterInterface {
    func navigationToHomeScreen()
}

final class LoginRouter: LoginRouterInterface, Router {

    unowned let viewController: LoginViewController

    func navigationToHomeScreen() {
        UIWindow.shared?.rootViewController = UINavigationController(rootViewController: AppScenes.main.viewController)
    }

    required init(viewController: LoginViewController) {
        self.viewController = viewController
        self.viewController.presenter = LoginPresenter(view: viewController,
                                                       router: self,
                                                       interactor: LoginInteractor())
    }

    deinit {
        LogInfo("\(type(of: self)) Deinit")
    }

}

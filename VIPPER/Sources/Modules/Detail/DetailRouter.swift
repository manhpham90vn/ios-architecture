//
//  DetailRouterInterface.swift
//  VIPPER
//
//  Created by Manh Pham on 06/06/2021.
//

import Foundation
import UIKit

protocol DetailRouterInterface {

}

final class DetailRouter: DetailRouterInterface, Router {

    unowned let viewController: DetailViewController

    required init(viewController: DetailViewController) {
        self.viewController = viewController
        viewController.presenter = DetailPresenter(view: viewController,
                                                   router: self,
                                                   interactor: DetailInteractor())
    }

    deinit {
        LogInfo("\(type(of: self)) Deinit")
    }

}

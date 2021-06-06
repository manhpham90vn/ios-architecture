//___FILEHEADER___

import UIKit

protocol ___FILEBASENAMEASIDENTIFIER___Interface {
    
}

class ___FILEBASENAMEASIDENTIFIER___: ___FILEBASENAMEASIDENTIFIER___Interface, Router {

    unowned var viewController: ___VARIABLE_productName___ViewController

    required init(viewController: ___VARIABLE_productName___ViewController) {
        self.viewController = viewController
        viewController.presenter = ___VARIABLE_productName___Presenter(view: viewController,
                                                   router: self,
                                                   interactor: ___VARIABLE_productName___Interactor())
    }

    deinit {
        print("\(type(of: self)) Deinit")
    }

}

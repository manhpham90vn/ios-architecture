//
//  LoginPresenter.swift
//  VIPPER
//
//  Created by Manh Pham on 3/4/21.
//

protocol LoginPresenterInterface: Presenter {
    var view: LoginViewInterface { get }
    var router: LoginRouterInterface { get }
    var interactor: LoginInteractorInterface { get }
    
    func didTapLoginButton()
}

final class LoginPresenter: LoginPresenterInterface, HasDisposeBag, HasActivityIndicator {

    unowned let view: LoginViewInterface
    let router: LoginRouterInterface
    let interactor: LoginInteractorInterface

    let activityIndicator = ActivityIndicator()
    let trigger = PublishRelay<Void>()

    init(view: LoginViewInterface,
         router: LoginRouterInterface,
         interactor: LoginInteractorInterface) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

    deinit {
        LogInfo("\(type(of: self)) Deinit")
        LeakDetector.instance.expectDeallocate(object: router as AnyObject)
        LeakDetector.instance.expectDeallocate(object: interactor as AnyObject)
    }

    func didTapLoginButton() {
        interactor
            .getURLAuthen()
            .trackActivity(activityIndicator)
            .flatMapLatest({ [weak self] url -> Driver<Token> in // need weak self here becase interactor have strong reference to AuthenticationServices
                guard let self = self else { return .empty() }
                guard let code = url.queryParameters?["code"] else {
                    self.view.showAlert(title: "Error", message: "Can not get code")
                    return .empty()
                }
                let params = AccessTokenParams(clientId: Configs.shared.env.clientID,
                                               clientSecret: Configs.shared.env.clientSecrets,
                                               code: code)
                return self.interactor.createAccessToken(params: params)
                    .trackActivity(self.activityIndicator)
                    .do(onError: { error in
                        self.view.showAlert(title: "Error", message: error.localizedDescription)
                    })
                    .asDriver(onErrorDriveWith: .empty())
            })
            .asDriver(onErrorDriveWith: .empty())
            .do(onNext: { token in
                if let token = token.accessToken {
                    self.interactor.saveToken(token: token)
                } else {
                    self.view.showAlert(title: "Error", message: "Can not get access token")
                }
            })
            .asDriver(onErrorDriveWith: .empty())
            .flatMap({ _ -> Driver<User> in
                return self.interactor.getInfo()
                    .trackActivity(self.activityIndicator)
                    .do(onError: { error in
                        self.view.showAlert(title: "Error", message: error.localizedDescription)
                    })
                    .asDriver(onErrorDriveWith: .empty())
            })
            .drive(onNext: { user in
                self.interactor.saveUserInfo(user: user)
                self.router.navigationToHomeScreen()
            })
            .disposed(by: disposeBag)
        
    }
    
}

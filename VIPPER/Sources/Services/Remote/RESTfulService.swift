//
//  RESTfulServiceComponent.swift
//  VIPER
//
//  Created by Manh Pham on 2/8/21.
//

import Foundation

protocol RESTfulService {
    func createAccessToken(params: AccessTokenParams) -> Observable<Token>
    func userReceivedEvents(params: EventParams) -> Observable<[Event]>
    func getInfo() -> Observable<User>
}

final class RESTfulServiceComponent: RESTfulService {

    func createAccessToken(params: AccessTokenParams) -> Observable<Token> {
        return ApiConnection.shared.request(target: MultiTarget(ApiRouter.createAccessToken(params: params)),
                                            type: Token.self)
    }
    
    func userReceivedEvents(params: EventParams) -> Observable<[Event]> {
        return ApiConnection.shared.requestArray(target: MultiTarget(ApiRouter.userReceivedEvents(params: params)),
                                                 type: Event.self)
    }
    
    func getInfo() -> Observable<User> {
        return ApiConnection.shared.request(target: MultiTarget(ApiRouter.getInfoUser),
                                            type: User.self)
    }
      
}

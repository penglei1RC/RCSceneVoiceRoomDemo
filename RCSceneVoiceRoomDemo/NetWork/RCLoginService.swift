//
//  RCLoginService.swift
//  RCSceneVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/26.
//

import Foundation
import Moya

let loginProvier = MoyaProvider<RCLoginService>(plugins: [RCWebServicePlugin])

enum RCLoginService {
    case login(mobile: String, code: String, userName: String?, portrait: String?, deviceId: String, region: String, platform: String)
}

extension RCLoginService: RCWebServiceType {
    var task: Task {
        switch self {
        case .login(let mobile, let code, let userName, let portrait, let deviceId, let region, let platform):
            return .requestParameters(parameters: ["mobile": mobile,
                                                   "verifyCode":code,
                                                   "userName": userName,
                                                   "portrait": portrait,
                                                   "deviceId": deviceId,
                                                   "platform": platform,
                                                   "region": region].compactMapValues{$0}, encoding: JSONEncoding.default)
        }
    }
    
    
    var path: String {
        switch self {
        case .login:
            return "user/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
}



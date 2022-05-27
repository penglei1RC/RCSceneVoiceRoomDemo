//
//  RCWebService.swift
//  RCSceneVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/26.
//

import Foundation
import Moya
import RCSceneRoom

// All components will be logged.
let RCWebServicePlugin: NetworkLoggerPlugin = {
    let plugin = NetworkLoggerPlugin()
    plugin.configuration.logOptions = .verbose
    return plugin
}()


protocol RCWebServiceType: TargetType {}

// common settings
extension RCWebServiceType {
    var baseURL: URL {
        return Environment.url
    }
    
    var headers: [String : String]? {
        var header = [String : String]()
        if let auth = UserDefaults.standard.authorizationKey() {
            header["Authorization"] = auth
        }
        
        header["BusinessToken"] = Environment.businessToken
        return header
    }
    
}








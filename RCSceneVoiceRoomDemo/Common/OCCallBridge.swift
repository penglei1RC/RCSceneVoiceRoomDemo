//
//  OCCallBridge.swift
//  RCSceneVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/27.
//

import Foundation
import RCSceneRoom
import RCSceneVoiceRoom
import UIKit

@objc class LoginBridge: NSObject {
    @objc static func login(phone: String, name: String, completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        let deviceId = UIDevice.current.identifierForVendor!.uuidString;
        let api = RCLoginService.login(mobile: phone,
                                       code: "123456",
                                       userName: name,
                                       portrait: nil,
                                       deviceId: deviceId,
                                       region: "+86",
                                       platform: "mobile")
        loginProvier.request(api) { result in
            switch result.map(RCSceneWrapper<User>.self) {
            case let .success(wrapper):
                
                guard let user = wrapper.data else {
                    let ocErr = NSError(domain: "login", code: -1, userInfo: [NSLocalizedDescriptionKey: wrapper.msg ?? "登录失败"])
                    completion(false, ocErr)
                    return
                }
                UserDefaults.standard.set(user: user)
                UserDefaults.standard.set(authorization: user.authorization)
                UserDefaults.standard.set(rongCloudToken: user.imToken)
                completion(true, nil)
            case let .failure(error):
                let ocErr = NSError(domain: "login", code: -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])
                completion(false, ocErr)
            }
        }
    }
    
    @objc static func logout() {
        UserDefaults.standard.clearLoginStatus()
    }
    
    @objc static func userDefaultsSavedToken() -> String {
        UserDefaults.standard.rongToken()  ?? ""
    }

}


@objc class VoiceRoomBridge:NSObject {
    static let shared = VoiceRoomBridge()
    
    var rooms: [RCSceneRoom]?
    
    struct VoiceRoomList: Codable {
        let totalCount: Int
        let rooms: [RCSceneRoom]
        let images: [String]
    }
    
   @objc static func roomList(completion: @escaping (_ rooms: [RoomListRoomModel]?, _ error: NSError?) -> Void) {
        roomProvider.request(.roomList(type: 1, page: 1, size: 20)) { result in
            switch result {
            case let .success(dataResponse):
                let wrapper = try! JSONDecoder().decode(RCSceneWrapper<VoiceRoomList>.self, from: dataResponse.data)
                SceneRoomManager.shared.backgrounds = wrapper.data?.images ?? [""]
                self.shared.rooms = wrapper.data?.rooms
                
                let ocRoomlist = RCNetResponseWrapper.yy_model(withJSON: dataResponse.data)
                completion(ocRoomlist?.data.rooms, nil)

            case let .failure(error):
                let ocErr = NSError(domain: "getRoomList", code: -2, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])
                completion(nil, ocErr)
            }
        }
    }
    
   @objc static func createRoom(name: String, fromVC: UIViewController) {
        let imageUrl = "https://img2.baidu.com/it/u=2842763149,821152972&fm=26&fmt=auto"
        roomProvider.request(.createRoom(name: name,
                                         themePictureUrl: imageUrl,
                                         backgroundUrl: imageUrl,
                                         kv: [],
                                         isPrivate: 0,
                                         password: "1234",
                                         roomType: 1)) { result in
            switch result.map(RCSceneWrapper<RCSceneRoom>.self) {
            case let .success(wrapper):
                if let roomInfo = wrapper.data {
                    let controller = RCVoiceRoomController(room: roomInfo)
                    controller.view.backgroundColor = .black
                    fromVC.navigationController?.navigationBar.isHidden = true
                    fromVC.navigationController?.pushViewController(controller, animated: true)
                    
                } else {
                    print("解析失败")
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc static func joinVoiceRoom(roomId: String, fromVC:UIViewController) {
        guard let roomInfo = self.shared.rooms?.filter({ $0.roomId == roomId }).first else {
            return
        }
        let controller = RCVoiceRoomController(room: roomInfo)
        controller.view.backgroundColor = .black
        fromVC.navigationController?.navigationBar.isHidden = true
        fromVC.navigationController?.pushViewController(controller, animated: true)
    }
}
    

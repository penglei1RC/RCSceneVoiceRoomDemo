//
//  ViewController.m
//  RCSceneVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/26.
//

#import "ViewController.h"
#import "RCRoomListController.h"
#import "RCSceneVoiceRoomDemo-Swift.h"
#import <RongIMLib/RongIMLib.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)loginIMInit:(id)sender {
    NSString *phone = self.phoneTextField.text;
    
    if (phone.length != 11) {
        [SVProgressHUD showInfoWithStatus:@"输入正确的手机号"];
        return ;
    }
    
    NSString *userName = [NSString stringWithFormat:@"用户%@", phone];
    [LoginBridge loginWithPhone:phone name:userName completion:^(BOOL success, NSError * _Nullable error) {
        if (!success) {
            return ;
        }
        NSString *imToken = [LoginBridge userDefaultsSavedToken];
        [self initIMWithToken:imToken];
    }];
    

}

- (void)initIMWithToken:(NSString *)token {
    [[RCIMClient sharedRCIMClient] initWithAppKey:[AppConfigs getRCKey]];
    [[RCIMClient sharedRCIMClient] connectWithToken:token
                                          timeLimit:5
                                           dbOpened:^(RCDBErrorCode code) {
        //消息数据库打开，可以进入到主页面
    } success:^(NSString *userId) {
        // 初始化成功
        NSLog(@"voice sdk initializ success");
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"IM初始化成功，当前id%@", userId]];
        });
        

    } error:^(RCConnectErrorCode status) {
        // 初始化失败
        NSLog(@"voice sdk initializ fail %ld",(long)status);
        if (status == RC_CONN_TOKEN_INCORRECT) {
            //token 非法，从 APP 服务获取新 token，并重连
        } else if(status == RC_CONNECT_TIMEOUT) {
            //连接超时，弹出提示，可以引导用户等待网络正常的时候再次点击进行连接
        } else {
            //无法连接 IM 服务器，请根据相应的错误码作出对应处理
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showInfoWithStatus:@"IM初始化失败"];
        });
        
    }];
}


- (IBAction)enterRoomList:(id)sender {
    RCRoomListController *vc = [RCRoomListController new];
    [self.navigationController pushViewController:vc animated:YES];
}



@end

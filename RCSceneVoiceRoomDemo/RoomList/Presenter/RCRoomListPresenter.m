//
//  RCRoomListPresenter.m
//  RCVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/20.
//

#import "RCRoomListPresenter.h"
#import "CreateRoomModel.h"
#import <CommonCrypto/CommonDigest.h>
#import "RCSceneVoiceRoomDemo-Swift.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface RCRoomListPresenter()
@property (nonatomic, copy, readwrite) NSArray<RoomListRoomModel *> *dataModels;
@end

@implementation RCRoomListPresenter

- (instancetype)init {
    if (self = [super init]) {
        self.dataModels = @[];
    }
    return self;
}

- (void)fetchRoomListWithCompletionBlock:(void(^)(BOOL success))completionBlock {
    [VoiceRoomBridge roomListWithCompletion:^(NSArray<RoomListRoomModel *> * _Nullable roomList, NSError * _Nullable error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"房间数据获取失败 code:%ld",(long)error.code]];
            !completionBlock ?: completionBlock(NO);
            return ;
        }
        
        self.dataModels = roomList;
        !completionBlock ?: completionBlock(YES);
        
    }];
}

@end

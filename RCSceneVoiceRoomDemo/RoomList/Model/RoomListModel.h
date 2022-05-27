//
//  RoomListModel.h
//  RCVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/20.
//

#import <Foundation/Foundation.h>
#import "RoomModel.h"

NS_ASSUME_NONNULL_BEGIN
@class RoomListRoomModel;
@class RoomListModel;

@interface RCNetResponseWrapper : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) RoomListModel *data;
@property (nonatomic, copy)   NSString *msg;
@end

@interface RoomListModel : NSObject

@property (nonatomic, nullable, strong) NSNumber *totalCount;
@property (nonatomic, nullable, copy)   NSArray<RoomListRoomModel *> *rooms;
@property (nonatomic, nullable, copy)   NSArray<NSString *> *images;

@end

@interface RoomListRoomModel : RoomModel
@property (nonatomic, nullable, strong) NSNumber *id;
@property (nonatomic, nullable, strong) NSNumber *stop;
@end


NS_ASSUME_NONNULL_END

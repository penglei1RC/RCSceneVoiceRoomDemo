//
//  RoomListModel.m
//  RCVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/20.
//

#import "RoomListModel.h"
#import <YYModel/YYModel.h>

@implementation RCNetResponseWrapper
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data": [RoomListModel class] };
}

@end

@implementation RoomListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"rooms" : [RoomListRoomModel class]};
}

@end

@implementation RoomListRoomModel

- (NSString *)description {
    return [self yy_modelDescription];
}

@end

//
//  AppDataManager.h
//  twoWayBeaconCommunication
//
//  Created by Teddy on 9/7/15.
//  Copyright (c) 2015 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDataManager : NSObject

+ (AppDataManager*)sharedManager;

@property NSString *UUID;
@property NSString *username;
@property NSInteger major;
@property NSInteger minor;

@end

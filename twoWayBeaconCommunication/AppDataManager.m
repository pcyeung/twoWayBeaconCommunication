//
//  AppDataManager.m
//  twoWayBeaconCommunication
//
//  Created by Teddy on 9/7/15.
//  Copyright (c) 2015 teddy. All rights reserved.
//

#import "AppDataManager.h"

@implementation AppDataManager

+ (AppDataManager*)sharedManager{
    static AppDataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


@end

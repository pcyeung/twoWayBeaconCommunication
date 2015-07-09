//
//  iBeaconEmitter.h
//  twoWayBeaconCommunication
//
//  Created by Teddy on 8/7/15.
//  Copyright (c) 2015 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>


@class iBeaconEmitter;
@protocol iBeaconEmitterDelegate <NSObject>

@optional
-(void)emittorStarted;
-(void)emittorStopped;

@end

@interface iBeaconEmitter : NSObject <CBPeripheralManagerDelegate>

+ (iBeaconEmitter*)sharedManager;

@property(nonatomic) id<iBeaconEmitterDelegate> delegate;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) NSDictionary *beaconPeripheralData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;

-(void)startEmittingWithMajor:(NSInteger)major minor:(NSInteger)minor;
-(void)stopEmitting;
-(BOOL)isEmitting;

@end

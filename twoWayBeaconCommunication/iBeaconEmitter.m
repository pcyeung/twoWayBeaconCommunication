//
//  iBeaconEmitter.m
//  twoWayBeaconCommunication
//
//  Created by Teddy on 8/7/15.
//  Copyright (c) 2015 teddy. All rights reserved.
//

#import "iBeaconEmitter.h"
#import "AppDataManager.h"

@implementation iBeaconEmitter

+ (iBeaconEmitter*)sharedManager{
    static iBeaconEmitter *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(id)init
{
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil
                                                                   options:nil];
    return self;
}

-(void)startEmittingWithMajor:(NSInteger)major minor:(NSInteger)minor
{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[AppDataManager sharedManager].UUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                major:major
                                                                minor:minor
                                                           identifier:[[NSBundle mainBundle] bundleIdentifier]];
    self.beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    if(self.peripheralManager.state == CBPeripheralManagerStatePoweredOn)
    {
        [self.peripheralManager startAdvertising:self.beaconPeripheralData];
//        [self.delegate emittorStarted];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.delegate emittorStarted];
        });

    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.delegate emittorStopped];
        });
    }
}

-(void)stopEmitting
{
    [self.peripheralManager stopAdvertising];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.delegate emittorStopped];
    });}

-(BOOL)canEmit
{
    if(self.peripheralManager.state == CBPeripheralManagerStatePoweredOn)
    {
        return YES;
    }else
    {
        return NO;
    }
}

-(BOOL)isEmitting
{
    return self.peripheralManager.isAdvertising;
}

#pragma mark CBPeripheralManagerDelegate
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Powered On");
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        NSLog(@"Powered Off");
    }
}

@end

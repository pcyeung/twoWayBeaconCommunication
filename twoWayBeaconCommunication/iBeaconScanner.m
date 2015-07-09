//
//  iBeaconScanner.m
//  twoWayBeaconCommunication
//
//  Created by Teddy on 8/7/15.
//  Copyright (c) 2015 teddy. All rights reserved.
//

#import "iBeaconScanner.h"
#import "AppDataManager.h"

@implementation iBeaconScanner
{
    CLLocationManager *locationManager;
    CLBeaconRegion *beaconRegion;
}

+ (iBeaconScanner*)sharedManager{
    static iBeaconScanner *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(iBeaconScanner *)init
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    NSUUID *UUID = [[NSUUID alloc] initWithUUIDString:[AppDataManager sharedManager].UUID];
    beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:UUID identifier:[[NSBundle mainBundle] bundleIdentifier]];
    return self;
}

-(void)startScanning
{
    [locationManager startMonitoringForRegion:beaconRegion];
    [locationManager startRangingBeaconsInRegion:beaconRegion];

}

-(void)stopScanning
{
    [locationManager stopMonitoringForRegion:beaconRegion];
    [locationManager stopRangingBeaconsInRegion:beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Beacon Found");
    [locationManager startRangingBeaconsInRegion:beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Left Region");
    [locationManager stopRangingBeaconsInRegion:beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    [self.delegate beaconFound:beacons.lastObject];
}

@end

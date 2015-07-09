//
//  iBeaconScanner.h
//  twoWayBeaconCommunication
//
//  Created by Teddy on 8/7/15.
//  Copyright (c) 2015 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class iBeaconScanner;
@protocol iBeaconScannerDelegate <NSObject>

@optional
-(void)beaconFound:(CLBeacon *)beacon;

@end

@interface iBeaconScanner : NSObject <CLLocationManagerDelegate>

+ (iBeaconScanner*)sharedManager;
@property(nonatomic) id<iBeaconScannerDelegate> delegate;


-(void)startScanning;
-(void)stopScanning;

@end

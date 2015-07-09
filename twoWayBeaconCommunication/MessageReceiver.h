//
//  MessageReceiver.h
//  twoWayBeaconCommunication
//
//  Created by Teddy on 10/7/15.
//  Copyright (c) 2015 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@class MessageReceiver;
@protocol MessageReceiverDelegate <NSObject>

@optional
-(void)messageReceived:(NSString *)message;

@end

@interface MessageReceiver : NSObject <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate>

+ (MessageReceiver*)sharedManager;
@property(nonatomic) id<MessageReceiverDelegate> delegate;

-(void)startMessageReceiver;
-(void)stopMessageReceiver;


@end

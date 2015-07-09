//
//  MessageSender.h
//  twoWayBeaconCommunication
//
//  Created by Teddy on 10/7/15.
//  Copyright (c) 2015 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@class MessageSender;
@protocol MessageSenderDelegate <NSObject>

-(void)messageSent;

@end

@interface MessageSender : NSObject <MCNearbyServiceBrowserDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate>

+ (MessageSender*)sharedManager;
@property (nonatomic)id<MessageSenderDelegate> delegate;

-(void)sendMessage:(NSString *)message toPeer:(NSString *)peerName;

@end

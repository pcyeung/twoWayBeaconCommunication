//
//  MessageReceiver.m
//  twoWayBeaconCommunication
//
//  Created by Teddy on 10/7/15.
//  Copyright (c) 2015 teddy. All rights reserved.
//

#import "MessageReceiver.h"
#import "AppDataManager.h"

static NSString * const XXServiceType = @"2way-service";

@implementation MessageReceiver

{
    MCPeerID *localPeerID;
    MCPeerID *incomingPeerID;
    MCSession *incommingSession;
    MCNearbyServiceAdvertiser *advertiser;
}

+ (MessageReceiver*)sharedManager{
    static MessageReceiver *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(id)init
{
    NSString *displayName = [NSString stringWithFormat:@"%ld-%ld",(long)[AppDataManager sharedManager].major,(long)[AppDataManager sharedManager].minor];
    localPeerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    return self;
}

-(void)startMessageReceiver
{
    advertiser =
    [[MCNearbyServiceAdvertiser alloc] initWithPeer:localPeerID
                                      discoveryInfo:nil
                                        serviceType:XXServiceType];
    advertiser.delegate = self;
    [advertiser startAdvertisingPeer];
}

-(void)stopMessageReceiver
{
    [advertiser stopAdvertisingPeer];
}

#pragma mark - MCNearbyServiceAdvertiserDelegate

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    
    incommingSession = [[MCSession alloc] initWithPeer:localPeerID
                                      securityIdentity:nil
                                  encryptionPreference:MCEncryptionNone];
    incommingSession.delegate = self;
    incomingPeerID = peerID;
    [incommingSession connectPeer:peerID withNearbyConnectionData:nil];
    
    invitationHandler(YES, incommingSession);
}

#pragma mark - MCSessionDelegate

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSString *message =
    [[NSString alloc] initWithData:data
                          encoding:NSUTF8StringEncoding];
    NSLog(@"iBeacon Message Received");
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Received" message:@"iBeacon Message Received" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    
//    [alert show];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.delegate messageReceived:message];
    });
    [session disconnect];
    [self stopMessageReceiver];
    [self startMessageReceiver];
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    
}


@end

//
//  MessageSender.m
//  twoWayBeaconCommunication
//
//  Created by Teddy on 10/7/15.
//  Copyright (c) 2015 teddy. All rights reserved.
//

#import "MessageSender.h"
#import "AppDataManager.h"

static NSString * const XXServiceType = @"2way-service";

@implementation MessageSender
{
    MCPeerID *localPeerID;
    MCPeerID *targetPeerID;
    MCSession *outgoingSession;
    MCNearbyServiceBrowser *outgoingBrowser;
    NSData *data;
}

+ (MessageSender*)sharedManager{
    static MessageSender *sharedMyManager = nil;
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

-(void)sendMessage:(NSString *)message toPeer:(NSString *)peerName
{
    targetPeerID = [[MCPeerID alloc] initWithDisplayName:peerName];
    data = [message dataUsingEncoding:NSUTF8StringEncoding];
    outgoingBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:localPeerID serviceType:XXServiceType];
    outgoingBrowser.delegate = self;
    [outgoingBrowser startBrowsingForPeers];
    //    MCBrowserViewController *browserViewController =
    //    [[MCBrowserViewController alloc] initWithBrowser:browser session:outgoingSession];
    //    browserViewController.delegate = self;
    //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //    UIViewController *rootViewController = window.rootViewController;
    //
    //
    //    [rootViewController presentViewController:browserViewController
    //                       animated:YES
    //                     completion:
    //     ^{
    //         [browser startBrowsingForPeers];
    //     }];
}

#pragma mark MCNearbyServiceBrowserDelegate
-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    if ([peerID.displayName isEqualToString:targetPeerID.displayName]) {
        outgoingSession = [[MCSession alloc] initWithPeer:localPeerID securityIdentity:nil encryptionPreference:MCEncryptionNone];
        outgoingSession.delegate = self;
        
        [outgoingBrowser invitePeer:peerID toSession:outgoingSession withContext:nil timeout:30];
        
        [outgoingBrowser stopBrowsingForPeers];
    }
}

-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    
}

-(void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
//    NSLog(@"[Error] %@", error);
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    if ([peerID.displayName isEqualToString:targetPeerID.displayName] && state == MCSessionStateConnected) {
        //        NSArray *peers = [[NSArray alloc] initWithObjects:targetPeerID, nil];
        NSError *error = nil;
        if (![outgoingSession sendData:data toPeers:outgoingSession.connectedPeers withMode:MCSessionSendDataReliable error:&error]) {
//            NSLog(@"[Error] %@", error);
        }else
        {
            NSLog(@"iBEacon Message Sent");
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sent" message:@"iBEacon Message Sent" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            
//            [alert show];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self.delegate messageSent];
            });
            [session disconnect];
        }
        
    }
    
    
}

-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

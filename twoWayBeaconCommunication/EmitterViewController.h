//
//  EmmitterViewController.h
//  twoWayBeaconCommunication
//
//  Created by Teddy on 8/7/15.
//  Copyright (c) 2015 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iBeaconEmitter.h"
#import "MessageReceiver.h"

@interface EmitterViewController : UIViewController <iBeaconEmitterDelegate, MessageReceiverDelegate>

@property (weak, nonatomic) IBOutlet UIButton *startStopButton;

@property (weak, nonatomic) IBOutlet UITextField *majorTextField;
@property (weak, nonatomic) IBOutlet UITextField *minorTextFirld;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

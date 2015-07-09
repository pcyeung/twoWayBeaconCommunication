//
//  EmmitterViewController.m
//  twoWayBeaconCommunication
//
//  Created by Teddy on 8/7/15.
//  Copyright (c) 2015 teddy. All rights reserved.
//

#import "EmitterViewController.h"
#import "AppDataManager.h"

@interface EmitterViewController ()

@end

@implementation EmitterViewController
{
    BOOL isEmiterStarted;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [iBeaconEmitter sharedManager].delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

}

-(void)viewWillAppear:(BOOL)animated
{
//    isEmiterStarted = [[iBeaconEmitter sharedManager] isEmitting];
    if( [[iBeaconEmitter sharedManager] isEmitting])
    {
        [self.startStopButton setTitle:@"Stop Emitting" forState:UIControlStateNormal];
        self.startStopButton.backgroundColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.5 alpha:1.0];
        self.statusLabel.text = @"Started";
        isEmiterStarted = true;
        self.majorTextField.enabled = false;
        self.minorTextFirld.enabled = false;
    }else
    {
        [self.startStopButton setTitle:@"Start Emitting" forState:UIControlStateNormal];
        self.startStopButton.backgroundColor = [UIColor colorWithRed:68.f/255.f green:177.f/255.f blue:215.f/255.f alpha:1.0];
        self.statusLabel.text = @"Ready";
        isEmiterStarted = false;
        self.majorTextField.enabled = true;
        self.minorTextFirld.enabled = true;
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[iBeaconEmitter sharedManager] stopEmitting];
    [iBeaconEmitter sharedManager].delegate = nil;
    
    [[MessageReceiver sharedManager] stopMessageReceiver];
    [MessageReceiver sharedManager].delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickOnStartStopButton:(id)sender {
    isEmiterStarted = !isEmiterStarted;
    
    if(isEmiterStarted)
    {
        NSInteger major = [self.majorTextField.text integerValue];
        NSInteger minor = [self.minorTextFirld.text integerValue];
        [AppDataManager sharedManager].major = major;
        [AppDataManager sharedManager].minor = minor;
        [[iBeaconEmitter sharedManager] startEmittingWithMajor:major minor:minor];
        [[MessageReceiver sharedManager] startMessageReceiver];
        [MessageReceiver sharedManager].delegate = self;

    }else
    {
       
        [[iBeaconEmitter sharedManager] stopEmitting];
        [[MessageReceiver sharedManager] stopMessageReceiver];
        [MessageReceiver sharedManager].delegate = nil;
    }
}

-(void)dismissKeyboard {
    [self.majorTextField resignFirstResponder];
    [self.minorTextFirld resignFirstResponder];
}

#pragma mark iBeaconEmittorDelegate

-(void)emittorStarted
{
    [self.startStopButton setTitle:@"Stop Emitting" forState:UIControlStateNormal];
    self.startStopButton.backgroundColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.5 alpha:1.0];
    self.statusLabel.text = @"Started";
    isEmiterStarted = true;
    self.majorTextField.enabled = false;
    self.minorTextFirld.enabled = false;
}

-(void)emittorStopped
{
    [self.startStopButton setTitle:@"Start Emitting" forState:UIControlStateNormal];
    self.startStopButton.backgroundColor = [UIColor colorWithRed:68.f/255.f green:177.f/255.f blue:215.f/255.f alpha:1.0];
    self.statusLabel.text = @"Ready";
    isEmiterStarted = false;
    self.majorTextField.enabled = true;
    self.minorTextFirld.enabled = true;
}

#pragma mark MessageReceiverDelegate
-(void)messageReceived:(NSString *)message
{
//    [[iBeaconEmitter sharedManager] stopEmitting];
//    [self performSegueWithIdentifier:@"messageReceived" sender:self];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Received"
                                                   message: [[NSString alloc] initWithFormat:@"%@ sent you a message", message]
                                                  delegate: nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

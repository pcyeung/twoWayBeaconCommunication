//
//  ScannerViewController.m
//  twoWayBeaconCommunication
//
//  Created by Teddy on 8/7/15.
//  Copyright (c) 2015 teddy. All rights reserved.
//

#import "ScannerViewController.h"
#import "iBeaconScanner.h"
#import "MessageSender.h"
#import "AppDataManager.h"

@interface ScannerViewController ()

@end

@implementation ScannerViewController
{
    BOOL messageSent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.usernameTextField.delegate = self;
    [AppDataManager sharedManager].username = self.usernameTextField.text;
    [iBeaconScanner sharedManager].delegate = self;
    [[iBeaconScanner sharedManager] startScanning];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[iBeaconScanner sharedManager] stopScanning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [AppDataManager sharedManager].username = newString;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    [self.usernameTextField resignFirstResponder];
    return YES;
}

-(void)dismissKeyboard {
    [self.usernameTextField resignFirstResponder];
}

-(void)beaconFound:(CLBeacon *)beacon
{
    if(beacon.proximity == 0)
    {
        self.nearbyLabel.text = @"Not Found";
        self.majorLabel.text = [NSString stringWithFormat:@"%@",beacon.major];
        self.minorLabel.text = [NSString stringWithFormat:@"%@",beacon.minor];
        self.accuracyLabel.text = [NSString stringWithFormat:@"%f", beacon.accuracy];
        self.proximityLabel.text = [NSString stringWithFormat:@"%ld",(long)beacon.proximity];
        self.rssiLabel.text = [NSString stringWithFormat:@"%ld",(long)beacon.rssi];

    }else
    {
        self.nearbyLabel.text = @"Found";
        self.majorLabel.text = [NSString stringWithFormat:@"%@",beacon.major];
        self.minorLabel.text = [NSString stringWithFormat:@"%@",beacon.minor];
        self.accuracyLabel.text = [NSString stringWithFormat:@"%f", beacon.accuracy];
        self.proximityLabel.text = [NSString stringWithFormat:@"%ld",(long)beacon.proximity];
        self.rssiLabel.text = [NSString stringWithFormat:@"%ld",(long)beacon.rssi];
        
        if(beacon.proximity == 1 && !messageSent)
        {
            // MC
            NSString *peerID = [NSString stringWithFormat:@"%@-%@",beacon.major, beacon.minor];
            [[MessageSender sharedManager] sendMessage:[AppDataManager sharedManager].username toPeer:peerID];
            [MessageSender sharedManager].delegate = self;
            messageSent = YES;
        }
    }
    
}

#pragma mark MessageSenderDelegate
-(void)messageSent
{
    [self.navigationController popViewControllerAnimated:YES];
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

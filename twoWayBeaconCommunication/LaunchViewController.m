//
//  LaunchViewController.m
//  twoWayBeaconCommunication
//
//  Created by Teddy on 9/7/15.
//  Copyright (c) 2015 teddy. All rights reserved.
//

#import "LaunchViewController.h"
#import "AppDataManager.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.UUIDTextField.text = [AppDataManager sharedManager].UUID;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

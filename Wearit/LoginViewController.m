//
//  LoginViewController.m
//  Wearit
//
//  Created by Ajeet Pratap on 27/05/15.
//  Copyright (c) 2015 Ajeet Pratap. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, Lets go on our home screen
         [self performSegueWithIdentifier: @"showMain" sender: self];
    }
    else {
        [_FBLogin setDelegate:self];
        _FBLogin.readPermissions = @[@"public_profile", @"email"];
    }
    
    
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

#pragma mark - Facebook delegate protocols

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error)
    {
        // Process error
    }
    else if (result.isCancelled)
    {
        // Handle cancellations
    }
    else
    {
        if ([result.grantedPermissions containsObject:@"email"])
        {
            //save the user data with the below code. we are not saving that info for now.
            
           /* [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id data, NSError *error) {
                 if (!error) {
                     NSLog(@"fetched user:%@", data);
                 }
             }];*/
            [self performSegueWithIdentifier: @"showMain" sender: self];
            
        }
    }
}


-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    //put your logout logic here. we are not doing that for now.
}



@end

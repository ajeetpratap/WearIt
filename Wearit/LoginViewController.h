//
//  LoginViewController.h
//  Wearit
//
//  Created by Ajeet Pratap on 27/05/15.
//  Copyright (c) 2015 Ajeet Pratap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController : UIViewController <FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *FBLogin;

@end

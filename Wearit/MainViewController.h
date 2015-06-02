//
//  MainViewController.h
//  Wearit
//
//  Created by Ajeet Pratap on 27/05/15.
//  Copyright (c) 2015 Ajeet Pratap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cardView.h"

@interface MainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UILabel *weatherString;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *weatherDesc;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end

//
//  closetViewController.h
//  Wearit
//
//  Created by Ajeet Pratap on 30/05/15.
//  Copyright (c) 2015 Ajeet Pratap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface closetViewController : UICollectionViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (nonatomic, strong) NSArray *shirtArray;
@property (nonatomic, strong) NSArray *pantArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, retain) NSArray *arrays;

@end

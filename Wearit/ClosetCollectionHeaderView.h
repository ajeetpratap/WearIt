//
//  ClosetCollectionHeaderView.h
//  Wearit
//
//  Created by Ajeet Pratap on 30/05/15.
//  Copyright (c) 2015 Ajeet Pratap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClosetCollectionHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *addClothBtn;


@end

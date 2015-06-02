//
//  cardView.h
//  Wearit
//
//  Created by Ajeet Pratap on 01/06/15.
//  Copyright (c) 2015 Ajeet Pratap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableView.h"

@interface cardView : UIView<DraggableViewDelegate>
@property (retain,nonatomic)NSMutableArray* allCards;

//methods called in DraggableView
-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;
@end

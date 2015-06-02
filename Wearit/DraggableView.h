//
//  DraggableView.h
//  Wearit
//
//  Created by Ajeet Pratap on 30/05/15.
//  Copyright (c) 2015 Ajeet Pratap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayView.h"

@protocol DraggableViewDelegate <NSObject>

-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;

@end

@interface DraggableView : UIView

@property (weak) id <DraggableViewDelegate> delegate;

@property (nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic)CGPoint originalPoint;
@property (nonatomic,strong)OverlayView* overlayView;
@property (nonatomic,strong)UILabel* information;
@property (nonatomic,strong)UIImageView *topWear;
@property (nonatomic,strong)UIImageView *bottomWear;


@end

//
//  cardView.m
//  Wearit
//
//  Created by Ajeet Pratap on 01/06/15.
//  Copyright (c) 2015 Ajeet Pratap. All rights reserved.
//

#import "cardView.h"

@interface cardView()
-(double) factorial: (int) value;
@end

@implementation cardView {
    NSInteger cardsLoadedIndex; //the index of the card you have loaded into the loadedCards array last
    NSMutableArray *loadedCards; //the array of card loaded
    UIImageView *topWear;
    UIImageView *bottomWear;
    NSString *path;
    NSArray* shirts;
    NSArray* pants;
    NSString *favPath;
    NSMutableArray *favData;
    NSMutableDictionary *favPair;
    int maxCard;
    
    
}

static const int MAX_BUFFER_SIZE = 2; // max number of cards loaded at any given time, must be greater than 1
static const float CARD_HEIGHT = 500; // height of the draggable card
static const float CARD_WIDTH = 320; // width of the draggable card

@synthesize allCards;//all the cards

- (id)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
            [super layoutSubviews];
            [self setupView];
            loadedCards = [[NSMutableArray alloc] init];
            allCards = [[NSMutableArray alloc] init];
            cardsLoadedIndex = 0;
            [self loadCards];
        }
        return self;
    
}

-(void)setupView
{
    self.backgroundColor = [UIColor whiteColor];
    favData = [[NSMutableArray alloc]init];
    
    //Get the documents directory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    path = [documentsDirectory stringByAppendingPathComponent:@"closet.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) {
        
        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"closet.plist"] ];
    }
    //Load the data from the plist and fill it
    NSMutableDictionary *savedValue = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    NSArray *value = (NSArray*)[savedValue objectForKey:@"summer"];
    
    shirts =  [value objectAtIndex:0];
    pants = [value objectAtIndex:1];
    
    
    //finding the combination that can occur with 'n' no. of shirts and pants
    int total = (int)(shirts.count+pants.count);
    maxCard = [self factorial:total]/([self factorial:2]*[self factorial:total-2]);
    
    //removing the combination that might occur for shirt to shirt or pant to pant pairing
    int shirt2shirtCombination = [self factorial:(int)shirts.count]/([self factorial:2]*[self factorial:(int)shirts.count-2]);
    int pant2pantCombination = [self factorial:(int)pants.count]/([self factorial:2]*[self factorial:(int)pants.count-2]);
    
    //final number of cards that will be available with us will be
    maxCard = maxCard - (shirt2shirtCombination + pant2pantCombination);
    
    //get our fav.plist ready
     favPath = [documentsDirectory stringByAppendingPathComponent:@"myfav.plist"];
    NSFileManager *favFileManager = [NSFileManager defaultManager];
    
    if (![favFileManager fileExistsAtPath: favPath]) {
        
        favPath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"myfav.plist"] ];
    }
    if ([fileManager fileExistsAtPath: favPath]) {
        favPair = [[NSMutableDictionary alloc] initWithContentsOfFile:favPath];
        [favData addObjectsFromArray:[favPair objectForKey:@"summer"]];
    }

    
}

-(DraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index
{
    DraggableView *draggableView = [[DraggableView alloc]initWithFrame:CGRectMake(((self.frame.size.width - CARD_WIDTH)/2)-20.0f, (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT)];
    
    int shirtCount = (int)shirts.count;
    int bottomCount = (int)pants.count;
    int randomShirtIndex = arc4random() % shirtCount;
    int randomPantIndex = arc4random() % bottomCount;
    
        UIImage *topImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[shirts objectAtIndex:randomShirtIndex]]];
        UIImage *bottomImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[pants objectAtIndex:randomPantIndex]]];
    draggableView.topWear.image = topImage;
    draggableView.bottomWear.image = bottomImage;
    draggableView.delegate = self;
    return draggableView;
}

// loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCards
{
    if(maxCard > 0) {
        NSInteger numLoadedCardsCap =((maxCard > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:maxCard);
        //if the buffer size is greater than the data size, there will be an array error, so this makes sure that doesn't happen
        
        // loop through the maxcard  to create a card
        for (int i = 0; i<maxCard; i++) {
            DraggableView* newCard = [self createDraggableViewWithDataAtIndex:i];
            [allCards addObject:newCard];
            
            if (i<numLoadedCardsCap) {
                // adds a small number of cards to be loaded
                [loadedCards addObject:newCard];
            }
        }
        
        // displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that not all the cards
        // are showing at once and clogging a ton of data
        for (int i = 0; i<[loadedCards count]; i++) {
            if (i>0) {
                [self insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
            } else {
                [self addSubview:[loadedCards objectAtIndex:i]];
            }
            cardsLoadedIndex++; // we loaded a card into loaded cards, so we have to increment
        }
    }
}


-(void)cardSwipedLeft:(UIView *)card;
{
    [loadedCards removeObjectAtIndex:0]; //card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;// loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
}


-(void)cardSwipedRight:(UIView *)card
{
    //Using our swiped card and converting the whole swiped view into image and saving it in our document directory
    DraggableView *c = (DraggableView *)card;
    c.overlayView.alpha = 0.0f;
    UIGraphicsBeginImageContext(c.frame.size);
    [c.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data=UIImagePNGRepresentation(viewImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"fav%lul",(unsigned long)favData.count]];
    [data writeToFile:strPath atomically:YES];
    
    [favData addObject:[NSString stringWithFormat:@"fav%lul.png",(unsigned long)favData.count]];
    [favPair setObject:favData forKey:@"summer"];
    [favPair writeToFile:favPath atomically:YES];
    [loadedCards removeObjectAtIndex:0]; //card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { // if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;// loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    
}

//calculate the factorial
-(double) factorial: (int) value {
    double tempResult = 1;
    for (int i=2; i<=value; i++) {
        tempResult *= (double)i;
    }
    return tempResult;
}


@end

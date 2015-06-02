//
//  FavViewController.m
//  Wearit
//
//  Created by Ajeet Pratap on 30/05/15.
//  Copyright (c) 2015 Ajeet Pratap. All rights reserved.
//

#import "FavViewController.h"
#import "SWRevealViewController.h"

@interface FavViewController ()
{
    NSArray* favPair;
}

@end

@implementation FavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        //modify the SWRevealViewController a bit
        self.revealViewController.rearViewRevealWidth = 80.0f;
        self.revealViewController.rearViewRevealDisplacement = 80.0f;
        
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
    }
    
    //Load the data from the plist
    //Get the documents directory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:@"myfav.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) {
        
        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"myfav.plist"] ];
    }
    //Load the data from the plist and fill it
    NSMutableDictionary *favData;
    if ([fileManager fileExistsAtPath: path]) {
        favData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
    }
    favPair = [NSArray arrayWithArray:[favData valueForKey:@"summer"]];
    NSLog(@"%@",favPair);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSLog(@"%lu",(unsigned long)favPair.count);
    return favPair.count;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
   // NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",
                      [favPair objectAtIndex:indexPath.row]] ];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *categoryImageView = (UIImageView *)[cell viewWithTag:100];
    categoryImageView.image = image;
    
    return cell;
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

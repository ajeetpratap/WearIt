//
//  closetViewController.m
//  Wearit
//
//  Created by Ajeet Pratap on 30/05/15.
//  Copyright (c) 2015 Ajeet Pratap. All rights reserved.
//

#import "closetViewController.h"
#import "SWRevealViewController.h"
#import "ClosetViewCell.h"
#import "ClosetCollectionHeaderView.h"

@interface closetViewController ()
{
    NSArray *list;
    NSString* uploadingNow;
    NSString *path;
}
@end

@implementation closetViewController

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
    
    list = [[NSArray alloc]initWithObjects:@"Shirt",@"Trouser", nil];
    _titleArray = [[NSArray alloc] initWithObjects:@"Top Wear", @"Trousers", nil];
    //loads your closet
    [self loadCollection];
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) loadCollection {
    //Get the documents directory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    path = [documentsDirectory stringByAppendingPathComponent:@"closet.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) {
        
        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"closet.plist"] ];
    }
    
    NSMutableDictionary *data;
    
    if ([fileManager fileExistsAtPath: path]) {
        
        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
        NSArray *value = (NSArray*)[data objectForKey:@"summer"];
        
        _shirtArray =  [NSArray arrayWithArray:[value objectAtIndex:0]];
        NSLog(@"%@",_shirtArray);
        _pantArray = [NSArray arrayWithArray:[value objectAtIndex:1]];
        _arrays = [[NSArray alloc] initWithObjects:_shirtArray , _pantArray, nil];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[_arrays objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_arrays count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        ClosetCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        NSString *title = [[NSString alloc]initWithFormat:@"%@ Collection", [list objectAtIndex:indexPath.section]];
        headerView.title.text = title;
        NSString *BtnTitle = [[NSString alloc]initWithFormat:@"Add %@", [list objectAtIndex:indexPath.section]];
        [headerView.addClothBtn setTitle:BtnTitle forState:UIControlStateNormal];
        reusableview = headerView;
    }
    return reusableview;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    ClosetViewCell *cell = (ClosetViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *closetImageView = (UIImageView *)[cell viewWithTag:100];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
   NSString* _path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",                                                                         [_arrays[indexPath.section]objectAtIndex:indexPath.row]]];
    UIImage *myImage = [UIImage imageWithContentsOfFile:_path];
    //check the image is found at the given path if not get it from the app bundle
    if(!myImage)
    {
        closetImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",                                                                         [_arrays[indexPath.section]objectAtIndex:indexPath.row]]];
    }
    else{
        closetImageView.image = [UIImage imageWithContentsOfFile:_path];
    }
    
    return cell;
}



- (void)selectPhoto:(UIButton *)sender {

    NSLog(@"%@",sender.titleLabel.text);
    uploadingNow = [NSString stringWithFormat:@"%@",sender.titleLabel.text];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSLog(@"%@",chosenImage);
    //self.imageView.image = chosenImage;
    NSData *imageData=UIImagePNGRepresentation(chosenImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if([uploadingNow  isEqual: @"Add Shirt"])
    {
        NSString *strPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"myshirt%lu.png",(unsigned long)_shirtArray.count]];
        [imageData writeToFile:strPath atomically:YES];
        //update the plist
        NSMutableDictionary *newData = [[NSMutableDictionary alloc]init];
        NSMutableArray *newShirtArray = [NSMutableArray arrayWithArray:_shirtArray];
        [newShirtArray addObject:[NSString stringWithFormat:@"myshirt%lu.png",(unsigned long)_shirtArray.count]];
        NSArray *summer = [NSArray arrayWithObjects:newShirtArray,_pantArray, nil];
        [newData setObject:summer forKey:@"summer"];
        [newData writeToFile:path atomically:YES];
        
    }
    else{
        NSString* strPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mypant%lu.png",(unsigned long)_pantArray.count]];
        [imageData writeToFile:strPath atomically:YES];
        //update the plist
        NSMutableDictionary *newData = [[NSMutableDictionary alloc]init];
        NSMutableArray *newPantArray = [NSMutableArray arrayWithArray:_pantArray];
        [newPantArray addObject:[NSString stringWithFormat:@"mypant%lu.png",(unsigned long)_pantArray.count]];
        NSArray *summer = [NSArray arrayWithObjects:_shirtArray,newPantArray, nil];
        [newData setObject:summer forKey:@"summer"];
        [newData writeToFile:path atomically:YES];
    }
    [self loadCollection];
    [self.collectionView reloadData];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
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

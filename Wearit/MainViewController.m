//
//  MainViewController.m
//  Wearit
//
//  Created by Ajeet Pratap on 27/05/15.
//  Copyright (c) 2015 Ajeet Pratap. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "OWMWeatherAPI.h"
#import "cardView.h"


@interface MainViewController () {
    OWMWeatherAPI *_weatherAPI;
    NSDateFormatter *_dateFormatter;
    int downloadCount;
    int maxCard;
}
@property (nonatomic, strong) NSMutableArray *cards;

@end

@implementation MainViewController {
    NSArray *sideMenu;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self intialLoad];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        //modify the SWRevealViewController a bit
        self.revealViewController.rearViewRevealWidth = 80.0f;
        self.revealViewController.rearViewRevealDisplacement = 80.0f;
        
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
       // [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        float width = self.view.frame.size.width;
        float frameHeight = self.view.frame.size.height - 140.0f;
        NSLog(@"%f ---> %f",width,frameHeight);
        
        
    }
    
    //Implementing OpenWeather API
    downloadCount = 0;
    
    NSString *dateComponents = @"H:m yyMMMMd";
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:dateComponents options:0 locale:[NSLocale systemLocale] ];
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:dateFormat];
    
    _weatherAPI = [[OWMWeatherAPI alloc] initWithAPIKey:@"c16050e5379a8e482870af284d1900c8"];
    // We want localized strings according to the prefered system language
    [_weatherAPI setLangWithPreferedLanguage];
    
    // We want the temperatures in celcius, you can also get them in farenheit.
    [_weatherAPI setTemperatureFormat:kOWMTempCelcius];
    
    [self.activityIndicator startAnimating];
    
    [_weatherAPI currentWeatherByCityName:@"Mumbai" withCallback:^(NSError *error, NSDictionary *result) {
        downloadCount++;
        if (downloadCount > 0) [self.activityIndicator stopAnimating];
        
        if (error) {
            // Handle the error
            return;
        }
         NSLog(@"found: %@", result);
        self.city.text = [NSString stringWithFormat:@"%@",result[@"name"]];
        
        self.weatherString.text = [NSString stringWithFormat:@"%.1f℃",
                                 [result[@"main"][@"temp"] floatValue] ];
        
        self.weatherDesc.text = [NSString stringWithFormat:@"%@, we suggest",result[@"weather"][0][@"description"]];
        CGRect frame = CGRectMake(0.0f, 120.0f, 414.0f,527.0f );
        cardView *allCards = [[cardView alloc]initWithFrame:frame];
        [self.view addSubview:allCards];
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) intialLoad {
    //Get the documents directory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"closet.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) {
        
        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"closet.plist"] ];
    }
    
    NSMutableDictionary *data;
    
    if ([fileManager fileExistsAtPath: path]) {
        
        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else {
        // If the file doesn’t exist, create an empty dictionary
        data = [[NSMutableDictionary alloc] init];
        //fill the empty array with our dummy data
        NSArray *top = @[@"shirt0.jpg",@"shirt1.jpg",@"shirt2.jpg",@"shirt3.jpg"];
        NSArray *bottom = @[@"pant0.jpg",@"pant1.jpg",@"pant2.jpg",@"pant3.jpg"];
        NSArray *summer = [NSArray arrayWithObjects:top,bottom, nil];
        [data setObject:summer forKey:@"summer"];
        [data writeToFile:path atomically:YES];
        
        
    }
    
    //create or fav.plist also if its not available
    NSString *favPath = [documentsDirectory stringByAppendingPathComponent:@"myfav.plist"];
    NSFileManager *favFileManager = [NSFileManager defaultManager];
    
    if (![favFileManager fileExistsAtPath: favPath]) {
        
        favPath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"myfav.plist"] ];
    }
    NSMutableDictionary *favData;
    if ([fileManager fileExistsAtPath: favPath]) {
        favData = [[NSMutableDictionary alloc] initWithContentsOfFile:favPath];
        
    }
    else
    {
        favData = [[NSMutableDictionary alloc] init];
        [favData writeToFile:favPath atomically:YES];
    }
}

@end

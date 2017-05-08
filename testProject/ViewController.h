//
//  ViewController.h
//  testProject
//
//  Created by Greg Hetherington on 2017-05-02.
//  Copyright © 2017 Greg Hetherington. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic, readonly) NSMutableArray *users;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) NSMutableArray *profilePictureUrls;
@property (strong, nonatomic) NSString *nextPageUrl;
@property BOOL pageAvailable;

@property (weak, nonatomic) IBOutlet UITextField *txtboxSearch;
@property (weak, nonatomic) IBOutlet UITableView *tweetsTableView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end


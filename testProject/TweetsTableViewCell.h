//
//  TweetsTableViewCell.h
//  testProject
//
//  Created by Greg Hetherington on 2017-05-08.
//  Copyright © 2017 Greg Hetherington. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetsTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *username;

@property (nonatomic, weak) IBOutlet UITextView *tweet;

@property (nonatomic, weak) IBOutlet UIImageView *userPicture;

@end

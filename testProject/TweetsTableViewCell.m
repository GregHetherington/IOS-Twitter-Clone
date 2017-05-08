//
//  TweetsTableViewCell.m
//  testProject
//
//  Created by Greg Hetherington on 2017-05-08.
//  Copyright © 2017 Greg Hetherington. All rights reserved.
//

#import "TweetsTableViewCell.h"

@implementation TweetsTableViewCell

@synthesize username = _username;
@synthesize tweet= _tweet;
@synthesize userPicture = _userPicture;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

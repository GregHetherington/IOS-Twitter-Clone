//
//  UITableViewCell+ViewCell.h
//  
//
//  Created by Greg Hetherington on 2017-05-08.
//
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (ViewCell)

@property (nonatomic, weak) IBOutlet UILabel *username;

@property (nonatomic, weak) IBOutlet UITextView *tweet;

@property (nonatomic, weak) IBOutlet UIImageView *userPicture;

@end

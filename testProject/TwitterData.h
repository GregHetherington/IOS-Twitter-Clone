//
//  TwitterData.h
//  testProject
//
//  Created by Greg Hetherington on 2017-05-04.
//  Copyright © 2017 Greg Hetherington. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterData : NSObject


@property NSString * userName;
@property NSString * tweetText;
@property NSString * urlToImage;

-(id)initWithName:(NSString *)name_ andtweet:(NSString *)tweet_ andurl:(NSString *)url_;



@end

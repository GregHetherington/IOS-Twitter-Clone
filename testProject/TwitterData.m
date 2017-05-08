//
//  TwitterData.m
//  testProject
//
//  Created by Greg Hetherington on 2017-05-04.
//  Copyright © 2017 Greg Hetherington. All rights reserved.
//

#import "TwitterData.h"

@implementation TwitterData

//constructor
-(id)initWithName:(NSString *)name_ andtweet:(NSString *)tweet_ andurl:(NSString *)url_
{
    self = [super init];
    if (self) {
        self.userName = name_;
        self.tweetText = tweet_;
        self.urlToImage = url_;
    }
    return self;
}


@end

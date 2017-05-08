//
//  ViewController.m
//  Twitter
//
//  Created by Greg Hetherington on 2017-05-02.
//  Copyright © 2017 Greg Hetherington. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <AFImageDownloader.h>
#import "TwitterData.h"
#import "TweetsTableViewCell.h"

static NSString * const BaseURLString = @"https://api.twitter.com/1.1/search/tweets.json";

@interface ViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray *users;
@property (nonatomic) NSString *tokenType;
@property (nonatomic) NSString *accessToken;
@property (nonatomic) BOOL isSearchPaged;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://pbs.twimg.com/media/CAnneWrW8AAeGJE.jpg"]]];
    self.txtboxSearch.delegate = self;
    [self.tweetsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([TweetsTableViewCell class])
                                                     bundle:[NSBundle mainBundle]]
               forCellReuseIdentifier:NSStringFromClass([TweetsTableViewCell class])];
    
    self.users = [NSMutableArray array];
    self.tweets = [NSMutableArray array];
    self.profilePictureUrls = [NSMutableArray array];
    [self authenticateWithCompletion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.txtboxSearch) {
        [self.searchButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        return NO;
    }
    return YES;
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TweetsTableViewCell class])];
    
//    if(cell == nil)
//    {
//        cell = [self.tweetsTableView dequeueReusableCellWithIdentifier:NSStringFromClass([TweetsTableViewCell class])];
//    }
    
    NSURLRequest *profileImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.profilePictureUrls[indexPath.row]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
    
//    AFURLSessionManager *afSessionManager = [[AFURLSessionManager alloc] init];
    AFImageDownloader *afImageDownloader = [[AFImageDownloader alloc] init];
    [afImageDownloader downloadImageForURLRequest:profileImageRequest
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *responseObject) {
                                              cell.userPicture.image = responseObject;
    }
                                          failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        // TODO: add error log
    }];
    cell.username.text = self.users[[indexPath row]];
    cell.tweet.text = self.tweets[[indexPath row]];
    
    return cell;
}

- (void)scrollViewDidScroll: (UIScrollView *)scroll {
    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scroll.contentOffset.y;
    CGFloat maximumOffset = scroll.contentSize.height - scroll.frame.size.height;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 10.0) {
        if(_pageAvailable)
        {
            _pageAvailable = false;
            //increase the table size
            NSLog(@"Paging more data");
            //static NSString * const BaseURLString = @"https://api.twitter.com/1.1/search/tweets.json";
            //TODO: the fetch tweets call is using the base URL without the q=? parameter, you will have to modify the function for this call
            //NSString *FinalURL = [BaseURLString stringByAppendingString:self.nextPageUrl];
            self.isSearchPaged = true;
            [self fetchTweetsAndAuthenticateIfNeeded];
        }
    }
}


#pragma mark - IBActions

- (IBAction)searchButtonTapped:(id)sender {
    [self.view endEditing:YES];
    [self clearExistingData];
    [self fetchTweetsAndAuthenticateIfNeeded];
}

- (void)clearExistingData {
    [self.users removeAllObjects];
    [self.tweets removeAllObjects];
    [self.profilePictureUrls removeAllObjects];
}

- (NSString *)formattedUrlStringFromSearchField:(BOOL)isPaged{
    NSString *search = [self.txtboxSearch.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *url;
    if(isPaged)
    {
        url = BaseURLString;
        url = [url stringByAppendingString:self.nextPageUrl];
    }
    else
    {
        url = [BaseURLString stringByAppendingString:@"?q="];
        url = [url stringByAppendingString:search];
    }
    return url;
}

- (NSString *)formattedUrlStringNextPage{
    NSString *search = [self.txtboxSearch.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    return [BaseURLString stringByAppendingString:search];
}

#pragma mark - Private methods

- (void)fetchTweetsAndAuthenticateIfNeeded {
    if (self.tokenType && self.accessToken) {
        [self fetchAndDisplayTweets];
    } else {
        [self authenticateWithCompletion:^{
            [self fetchAndDisplayTweets];
        }];
    }
}

- (void)authenticateWithCompletion:(void (^)())completionBlock
{
    //Authenticate account
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSData *plainData = [[NSString stringWithFormat:@"%@:%@", @"CFMvDaHhOCwBeqMlPKDjeBODG", @"rV3L8VRTgCepmbVX25zXsSYPNzfczSv6kyky6AhwuLkr2ETYw1"] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedUsernameAndPassword = [plainData base64EncodedStringWithOptions:0];
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", encodedUsernameAndPassword];
    [manager.requestSerializer setValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    NSString *URL = @"https://api.twitter.com/oauth2/token?grant_type=client_credentials";
    [manager POST:URL parameters:nil progress:nil
          success:^(NSURLSessionDataTask *operation, id responseObject) {
              NSLog(@"Res: %@", responseObject);
              self.tokenType = [responseObject valueForKeyPath:@"token_type"];
              self.accessToken = [responseObject valueForKeyPath:@"access_token"];
              
              if (completionBlock) {
                  completionBlock();
              }
          }
     
          failure:^(NSURLSessionDataTask *operation, NSError *error) {
              NSLog(@"Auth error: %@", error);
          }];
}

- (void)fetchAndDisplayTweets {
    AFHTTPSessionManager *afSessionManager = [AFHTTPSessionManager manager];
    NSString *authHead = [NSString stringWithFormat:@"%@ %@", self.tokenType, self.accessToken];
    [afSessionManager.requestSerializer setValue:authHead forHTTPHeaderField:@"Authorization"];
    
    [afSessionManager GET:[self formattedUrlStringFromSearchField:self.isSearchPaged] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        self.isSearchPaged = false;
        if(responseObject)
        {
            
            for(NSDictionary *dictStat in [responseObject objectForKey:@"statuses"]) {
                
                [self.users addObject:[dictStat valueForKeyPath:@"user.screen_name"]];
                [self.tweets addObject:[dictStat valueForKeyPath:@"text"]];
                [self.profilePictureUrls addObject:[dictStat valueForKeyPath:@"user.profile_image_url_https"]];
                [self.tweetsTableView reloadData];
            }
            self.nextPageUrl = [responseObject valueForKeyPath:@"search_metadata.next_results"];
            _pageAvailable = true;
            
        } else{
            NSLog(@"Error did not receive response");
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end

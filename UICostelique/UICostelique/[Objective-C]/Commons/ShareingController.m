//
//  ShareingController.m
//  Sparkle Effects Editor
//
//  Created by Олег on 09.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import "ShareingController.h"
#import "UICosteliqueFunctions.h"
#import <Photos/Photos.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <AVFoundation/AVFoundation.h>
#import "UIView.h"

#define AnalytiAll NSString
#define logEvent stringWithFormat\

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface ShareingController ()
@property UIViewController *controller;
@end

@implementation ShareingController

- (IBAction)more_pressed:(UIView *)sender {
    [self startShareing];
    if (![self resourceToShare]) {
        return;
    }
    
    NSString *textToShare = [NSString stringWithFormat:@"Sparkle Effects Editor"];
    NSURL *urlToShare = [NSURL URLWithString:@"https://itunes.apple.com/"];// [NSURL URLWithString:@"https://itunes.apple.com/app/id1031187801"];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems: @[self.resourceToShare,urlToShare,textToShare] applicationActivities:@[]];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList];
    activityVC.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        [self completion:completed failText:nil];
    };
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.controller presentViewController:activityVC animated:YES completion:nil];
    } else {
        /*
//        UIPopoverPresentationController *contr = [[UIPopoverPresentationController alloc] initWithPresentedViewController:activityVC presentingViewController:nil];
        UIPopoverPresentationController *contr = activityVC.popoverPresentationController;
        contr.sourceView = sender;
        contr.sourceRect = CGRectMake(self.controller.view.frame.size.width/2, self.controller.view.frame.size.height/4, 0, 0);
        */
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController: activityVC];
        [popup presentPopoverFromRect:CGRectMake(self.controller.view.frame.size.width/2, self.controller.view.frame.size.height/4, 0, 0)inView:self.controller.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
    [AnalytiAll logEvent:@"shareing: other"];
}


- (IBAction)twitter_pressed:(id)sender {
    [AnalytiAll logEvent:@"shareing: twitter"];
    [self startShareing];
    [self shareResourceWithService:SLServiceTypeTwitter];
}

- (IBAction)facebook_pressed:(id)sender {
    [AnalytiAll logEvent:@"shareing: facebook"];
    [self startShareing];
    
    [self shareResourceWithService:SLServiceTypeFacebook];
}

- (IBAction)instagram_pressed:(id)sender {
    [AnalytiAll logEvent:@"shareing: instagram"];
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        [self shreToInstagram];
        
    } else if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized){
                    [self shreToInstagram];
                }
            });
        }];
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Access" message:@"Allow application use photo library" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:settings];
        [alert addAction:cancel];
        [topViewController() presentViewController:alert animated:YES completion:nil];
        
        __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [[NSNotificationCenter defaultCenter] removeObserver:observer];
            if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized){
                [self shreToInstagram];
            }
        }];
    }
}

-(void)shreToInstagram
{
    [self startShareing];
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetChangeRequest *request;
        if ([self.resourceToShare isKindOfClass:[UIImage class]]) {
            request = [PHAssetChangeRequest creationRequestForAssetFromImage:self.resourceToShare];
        } else if ([self.resourceToShare isKindOfClass:[NSURL class]]) {
            request = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:self.resourceToShare];
        }
        NSString *assetID = request.placeholderForCreatedAsset.localIdentifier;
        if (!assetID) {
            return;
        }
        NSURL *shareURL = [NSURL URLWithString:[@"instagram://library?AssetPath=" stringByAppendingString:assetID]];
        [[UIApplication sharedApplication] openURL:shareURL options:@{} completionHandler:^(BOOL success) {
            [self completion:success failText:@"Install instagram to share"];
        }];
    } error:nil];
}


// MARK: - shareing
-(void)startShareing
{
    self.controller = topViewController();
    [self.controller.view blockView];
}

-(void)completion:(BOOL)sucess failText:(NSString *)failText
{
    [self.controller.view unblockView];
    if (sucess) {
        [self showFloatingLabelWithText:@"Success" withCompletion:^{
            
        }];
    } else {
        [self showFloatingLabelWithText:failText ? : @"Sharing error" withCompletion:nil];
    }
}

-(void)shareResourceWithService:(NSString *)service
{
    SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:service];
    [composeViewController addImage:self.resourceToShare];
    if (service == SLServiceTypeTwitter) {
        [composeViewController addURL:[NSURL URLWithString:@"https://itunes.apple.com/app/id1031187801"]];
    } else if (service == SLServiceTypeFacebook) {
        //[composeViewController setInitialText:@"https://itunes.apple.com/app/id1031187801"];
    }
    composeViewController.completionHandler = ^(SLComposeViewControllerResult result) {
        if (result == SLComposeViewControllerResultDone) {
            [self completion:YES failText:nil];
        } else {
            [self completion:NO failText:@"Sharing error"];
        }
    };
    [self.controller presentViewController:composeViewController animated:YES completion:nil];
    
}


-(void)showFloatingLabelWithText:(NSString *)text withCompletion:(void(^)(void))completion
{
    UILabel *label = [UILabel new];
    label.text =  text;
    label.alpha = 0;
    float h = label.attributedText.size.height + 10;
    __block CGRect frame = CGRectMake(0, self.controller.view.frame.origin.y + self.controller.view.frame.size.height - 106+10, [UIScreen mainScreen].bounds.size.width, h);
    label.frame = frame;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    [self.controller.view addSubview:label];
    label.layer.zPosition = 2;
    [UIView animateWithDuration:.15 animations:^{
        label.alpha = 1;
        frame.origin.y -= 30;
        label.frame = frame;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
            [UIView animateWithDuration:.3 animations:^{
                label.alpha = 0;
                frame.origin.y -= 30;
                label.frame = frame;
                
            } completion:^(BOOL finished)
             {
                 [label removeFromSuperview];
             }];
        });
    }];
}


@end

#pragma clang diagnostic pop

//
//  ShareingController.h
//  Sparkle Effects Editor
//
//  Created by Олег on 09.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShareingController : NSObject
@property id resourceToShare;

- (IBAction)more_pressed:(UIView *)sender;
- (IBAction)twitter_pressed:(id)sender;
- (IBAction)facebook_pressed:(id)sender;
- (IBAction)instagram_pressed:(id)sender;

@end

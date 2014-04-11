//
//  JBTestScrollView.h
//  JBAttributedAwareScrollView
//
//  Created by Julian Bleecker on 4/10/14.
//  Copyright (c) 2014 Julian Bleecker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import <TTTAttributedLabel.h>
#import <UIColor+Crayola.h>

typedef void(^LinkWithURLHandler)(TTTAttributedLabel *label, NSURL *url);
typedef void(^LinkWithUserOrHashtagHandler)(TTTAttributedLabel *label, NSTextCheckingResult *result);

@interface JBAttributedAwareTextView : UIView <TTTAttributedLabelDelegate>
@property (strong, nonatomic) TTTAttributedLabel *label;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) LinkWithURLHandler linkWithURLHandler;
@property (strong, nonatomic) LinkWithUserOrHashtagHandler linkWithUserOrHashtagHandler;

- (void)boldText:(NSString *)str withFont:(UIFont *)boldFont;
- (void)setLinkWithURLHandler:(LinkWithURLHandler)handler;
- (void)setLinkWithUserOrHashtagHandler:(LinkWithUserOrHashtagHandler)handler;
- (void)highlightMentionsWithColor:(UIColor *)color isUnderlined:(BOOL)underlined;
- (void)setHightlightMentionsColor:(UIColor *)color;

- (void)setHighlightMentionsActiveColor:(UIColor *)color;
- (void)setURLLinkColor:(UIColor *)color;
- (void)setActiveURLLinkColor:(UIColor *)color;

//- (void)highlightMentionsColor:(UIColor *)color withActiveColor:(UIColor *)activeColor;

#pragma mark -- optional protocol methods from TTTAttributedLabel we might need..
/**
 Tells the delegate that the user did select a link to a URL.
 
 @param label The label whose link was selected.
 @param url The URL for the selected link.
 */
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url;


/**
 Tells the delegate that the user did select a link to a text checking result.
 
 @discussion This method is called if no other delegate method was called, which can occur by either now implementing the method in `TTTAttributedLabelDelegate` corresponding to a particular link, or the link was added by passing an instance of a custom `NSTextCheckingResult` subclass into `-addLinkWithTextCheckingResult:`.
 
 @param label The label whose link was selected.
 @param result The custom text checking result.
 */
- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result;


@end

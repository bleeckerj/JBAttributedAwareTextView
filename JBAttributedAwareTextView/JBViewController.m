//
//  JBViewController.m
//  JBAttributedAwareScrollView
//
//  Created by Julian Bleecker on 4/10/14.
//  Copyright (c) 2014 Julian Bleecker. All rights reserved.
//

#import "JBViewController.h"
#import <Masonry.h>
#import <UIColor+Crayola.h>
#import <TTTAttributedLabel.h>
#import "JBAttributedAwareTextView.h"

@interface JBViewController ()
@property TTTAttributedLabel *label;
@end

@implementation JBViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    JBAttributedAwareTextView *test = JBAttributedAwareTextView.new;
    [self.view addSubview:test];
    
//    self.view.backgroundColor = [UIColor crayolaMandarinPearlColor];
    test.clipsToBounds = YES;
    test.layer.shadowColor = [[UIColor blackColor] CGColor];
    test.layer.shadowOffset = CGSizeMake(0,2);
    test.layer.shadowOpacity = 0.15;
    
    //[test setFont:[UIFont fontWithName:@"DINAlternate-Bold" size:22]];
    [test setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:20]];
    [test setHightlightMentionsColor:[UIColor crayolaGrapeColor]];
    [test setURLLinkColor:[UIColor crayolaGrapeColor]];
    [test setActiveURLLinkColor:[UIColor crayolaRoseQuartzColor]];
    
    
    [test mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        //make.top.equalTo(@100);
        make.height.equalTo(@200);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        
    }];
    [test setText:@"Boredom DimSum is http://simply text of the printing and #typesetting industry. Lorem Ipsum http://has.com been the industry's @standard dummy text ever since the 1500s, when an unknown printer Lorem Ipsum took a galley of type and Lorem Ipsum scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."];
    
    //[test boldText:@"lorem ipsum" withFont:[UIFont fontWithName:@"AvenirNext-Bold" size:17]];
    
    
    
    [test setLinkWithUserOrHashtagHandler:^(TTTAttributedLabel *label, NSTextCheckingResult *result) {
        
        NSRange r = NSMakeRange(result.range.location+1, result.range.length-1);
        NSLog(@"match=%@", [label.text substringWithRange:r]);
    }];
    
    [test setLinkWithURLHandler:^(TTTAttributedLabel *label, NSURL *url) {
        NSLog(@"url=%@", url);
    }];
    
}


- (void)highlightMentionsInString:(NSString *)text withColor:(UIColor *)color isBold:(BOOL)bold isUnderlined:(BOOL)underlined
{
    NSRegularExpression *mentionExpression = [NSRegularExpression regularExpressionWithPattern:@"(?:^|\\s)((#|@)\\w+)" options:NO error:nil];
    
    NSArray *matches = [mentionExpression matchesInString:text
                                                  options:0
                                                    range:NSMakeRange(0, [text length])];
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match rangeAtIndex:1];
        NSString *mentionString = [text substringWithRange:matchRange];
        //NSRange linkRange = [text rangeOfString:mentionString];
        NSString* user = [mentionString substringFromIndex:1];
        NSString* linkURLString = [NSString stringWithFormat:@"user:%@", user];
        //NSLog(@"%@", linkURLString);
        
        NSArray *keys = [[NSArray alloc] initWithObjects:(id)kCTForegroundColorAttributeName,(id)kCTUnderlineStyleAttributeName
                         , nil];
        NSArray *objects = [[NSArray alloc] initWithObjects:color,[NSNumber numberWithInt:underlined ? kCTUnderlinePatternSolid : 0], nil];
        NSDictionary *linkAttributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
        
        
        [self.label addLinkWithTextCheckingResult:match attributes:linkAttributes];
        // [self.label addLinkToURL:[NSURL URLWithString:linkURLString] withRange:linkRange];
    }
}


- (NSArray *)rangesOfString:(NSString *)searchString inString:(NSString *)str {
    NSMutableArray *results = [NSMutableArray array];
    NSRange searchRange = NSMakeRange(0, [str length]);
    NSRange range;
    while ((range = [str rangeOfString:searchString options:NSCaseInsensitiveSearch range:searchRange]).location != NSNotFound) {
        [results addObject:[NSValue valueWithRange:range]];
        searchRange = NSMakeRange(NSMaxRange(range), [str length] - NSMaxRange(range));
    }
    return results;
}

//- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
//{
//    NSLog(@"url=%@", url);
//}
//
//- (void)attributedLabel:(TTTAttributedLabel *)label
//didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result
//{
//    //NSLog(@"result=%@", result);
//    NSRange r = NSMakeRange(result.range.location+1, result.range.length-1);
//    NSLog(@"match=%@", [label.text substringWithRange:r]);
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

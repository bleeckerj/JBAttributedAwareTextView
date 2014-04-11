//
//  JBAttributedAwareScrollView.m
//
//  Created by Julian Bleecker on 4/10/14.
//  Copyright (c) 2014 Julian Bleecker. All rights reserved.
//

#import "JBAttributedAwareTextView.h"
@interface JBAttributedAwareTextView()
@property (strong, nonatomic) UIScrollView *scrollView;
@end
@implementation JBAttributedAwareTextView
{
    UIColor *highlightMentionsColor;
    UIColor *urlLinkColor;
    UIColor *activeURLLinkColor;
}
@synthesize text, font;

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    highlightMentionsColor = [UIColor crayolaRazzleDazzleRoseColor];
    urlLinkColor = [UIColor crayolaBlueBellColor];
    activeURLLinkColor = [UIColor crayolaGlossyGrapeColor];
    
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    [self addSubview:self.scrollView];
    
    scrollView.backgroundColor = self.superview.backgroundColor;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.scrollView setBounces:NO];
    
    // We create a dummy contentView that will hold everything (necessary to use scrollRectToVisible later)
    UIView* contentView = UIView.new;
    [self.scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top).with.offset(0);
        make.left.equalTo(self.scrollView.mas_left);
        make.right.equalTo(self.scrollView.mas_right);
        make.bottom.equalTo(self.scrollView.mas_bottom);
        make.width.equalTo(self.scrollView.mas_width);
    }];
    UIView *lastView;
    
    self.label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    //setObject:[UIColor redColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    
    self.label.delegate = self;
    [contentView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];
    
    [self.label setLineBreakMode:NSLineBreakByWordWrapping];
    [self.label setNumberOfLines:0];
    
    self.label.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    self.label.font = [UIFont systemFontOfSize:14];
    self.label.textColor = [UIColor darkGrayColor];
    self.label.lineBreakMode = NSLineBreakByCharWrapping;
    self.label.numberOfLines = 0;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    lastView = self.label;
    
    UIView *sizingView = UIView.new;
    [scrollView addSubview:sizingView];
    [sizingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom);
        make.bottom.equalTo(contentView.mas_bottom);
    }];
    return self;
    
}

- (void)setFont:(UIFont *)_font
{
    self.label.font = _font;
}

- (void)setText:(NSString *)str
{
    // __block JBAttributedAwareScrollView *bself = self;
    text = str;
    
    [self.label setLinkAttributes:@{(NSString*)kCTForegroundColorAttributeName : urlLinkColor}];
    [self.label setActiveLinkAttributes:@{(NSString *)kCTForegroundColorAttributeName : activeURLLinkColor}];
    [self.label setText:self.text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        return mutableAttributedString;
    }];
    
    [self highlightMentionsWithColor:highlightMentionsColor isUnderlined:NO];
    
}

- (void)setURLLinkColor:(UIColor *)color
{
    urlLinkColor = color;
    if(text) {
    [self setText:text];
    [self setNeedsDisplay];
    }
}

- (void)setActiveURLLinkColor:(UIColor *)color
{
    activeURLLinkColor = color;
    if(text) {
        [self setText:text];
        [self setNeedsDisplay];
    }
}
- (void)setHightlightMentionsColor:(UIColor *)color
{
    highlightMentionsColor = color;
    if(text) {
    [self setText:text];
    [self setNeedsDisplay];
    }

}



- (void)setHighlightMentionsActiveColor:(UIColor *)color
{
    
    
    [self.label setActiveLinkAttributes:@{(NSString *)kCTForegroundColorAttributeName: color}];

}

- (void)boldText:(NSString *)str withFont:(UIFont *)boldFont
{
    //text = str;
    __block JBAttributedAwareTextView *bself = self;
    [self.label setText:self.text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        NSArray *lorems = [bself rangesOfString:str inString:bself.text];
        
        CTFontRef ctBoldFont = CTFontCreateWithName((__bridge CFStringRef)boldFont.fontName, boldFont.pointSize, NULL);
        if (ctBoldFont) {
            //
            for(int i=0; i<lorems.count; i++) {
                NSValue *v = [lorems objectAtIndex:i];
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)ctBoldFont range:[v rangeValue]];
                
            }
            
            //[mutableAttributedString addAttribute:(NSString *)kCT value:<#(id)#> range:<#(NSRange)#>]
            //[mutableAttributedString addAttribute:kTTTStrikeOutAttributeName value:[NSNumber numberWithBool:YES] range:strikeRange];
            CFRelease(ctBoldFont);
        }

        return mutableAttributedString;
    }];
    [self highlightMentionsWithColor:highlightMentionsColor isUnderlined:NO];

    
}

- (void)setLinkWithURLHandler:(LinkWithURLHandler)handler
{
    _linkWithURLHandler = handler;
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    if(self.linkWithURLHandler) {
        self.linkWithURLHandler(label, url);
    }
}

- (void)setLinkWithUserOrHashtagHandler:(LinkWithUserOrHashtagHandler)handler
{
    _linkWithUserOrHashtagHandler = handler;
}


- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result;
{
    if(self.linkWithUserOrHashtagHandler) {
        self.linkWithUserOrHashtagHandler(label, result);
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)highlightMentionsWithColor:(UIColor *)color isUnderlined:(BOOL)underlined
{
    NSRegularExpression *mentionExpression = [NSRegularExpression regularExpressionWithPattern:@"(?:^|\\s)((#|@)\\w+)" options:NO error:nil];
    
    NSArray *matches = [mentionExpression matchesInString:text
                                                  options:0
                                                    range:NSMakeRange(0, [text length])];
    for (NSTextCheckingResult *match in matches) {
        //        NSRange matchRange = [match rangeAtIndex:1];
        //        NSString *mentionString = [text substringWithRange:matchRange];
        //NSRange linkRange = [text rangeOfString:mentionString];
        //        NSString* user = [mentionString substringFromIndex:1];
        //        NSString* linkURLString = [NSString stringWithFormat:@"user:%@", user];
        
        NSArray *keys = [[NSArray alloc] initWithObjects:(id)kCTForegroundColorAttributeName,(id)kCTUnderlineStyleAttributeName
                         , nil];
        NSArray *objects = [[NSArray alloc] initWithObjects:color,[NSNumber numberWithInt:underlined ? kCTUnderlinePatternSolid : 0], nil];
        NSDictionary *linkAttributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
        
        
        [self.label addLinkWithTextCheckingResult:match attributes:linkAttributes];
        // [self.label addLinkToURL:[NSURL URLWithString:linkURLString] withRange:linkRange];
    }
    
}

- (void)highlightMentionsInString:(NSString *)string withColor:(UIColor *)color isBold:(BOOL)bold isUnderlined:(BOOL)underlined
{
    NSRegularExpression *mentionExpression = [NSRegularExpression regularExpressionWithPattern:@"(?:^|\\s)((#|@)\\w+)" options:NO error:nil];
    
    NSArray *matches = [mentionExpression matchesInString:text
                                                  options:0
                                                    range:NSMakeRange(0, [text length])];
    for (NSTextCheckingResult *match in matches) {
        //        NSRange matchRange = [match rangeAtIndex:1];
        //        NSString *mentionString = [text substringWithRange:matchRange];
        // NSRange linkRange = [text rangeOfString:mentionString];
        //        NSString* user = [mentionString substringFromIndex:1];
        //        NSString* linkURLString = [NSString stringWithFormat:@"user:%@", user];
        //        NSLog(@"%@", linkURLString);
        
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

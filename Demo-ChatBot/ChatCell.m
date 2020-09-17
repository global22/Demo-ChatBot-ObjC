//
//  ChatCell.m
//  Demo-ChatBot
//
//  Created by Imac  on 08/11/19.
//  Copyright © 2019 Global Corporation. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

-(void)setupViews {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    CGFloat width = UIScreen.mainScreen.bounds.size.width * 0.666;
    /* Bubble View */
    self.bubbleView = [[UIView alloc] init];
    [self.contentView addSubview:self.bubbleView];
    [self.bubbleView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.bubbleView setBackgroundColor:[UIColor colorNamed:@"grayBubbleColor"]];
    [self.bubbleView.layer setCornerRadius:16];
    [self.bubbleView.layer setMasksToBounds:YES];
    
    self.bubbleRightAnchor = [self.bubbleView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor
                                                                          constant:-8];
    [self.bubbleRightAnchor setActive:YES];
    
    self.bubbleLeftAnchor = [self.bubbleView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor
                                                                       constant:8];
    [self.bubbleLeftAnchor setActive:NO];
    
    [[self.bubbleView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor] setActive:YES];
    
    self.bubbleWidthAnchor = [self.bubbleView.widthAnchor constraintEqualToConstant:width];
    [self.bubbleWidthAnchor setActive: YES];
    
    [[self.bubbleView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-20] setActive:YES];
    
    
    /* Text View */
    self.massageTextView = [[UITextView alloc] init];
    [self.contentView addSubview:self.massageTextView];
    [self.massageTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.massageTextView setEditable:NO];
    [self.massageTextView setSelectable:NO];
    [self.massageTextView setScrollEnabled:NO];
    [self.massageTextView setText:@"Hello there!"];
    [self.massageTextView setBackgroundColor:UIColor.clearColor];
    [self.massageTextView setTextColor:UIColor.blackColor];
    [self.massageTextView setFont:[UIFont systemFontOfSize:16]];
    [self.massageTextView sizeToFit];
    [self.massageTextView setTextAlignment:NSTextAlignmentLeft];
    
    
    [[self.massageTextView.leftAnchor constraintEqualToAnchor:self.bubbleView.leftAnchor
                                              constant:8] setActive:YES];
    [[self.massageTextView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor] setActive:YES];
    [[self.massageTextView.rightAnchor constraintEqualToAnchor:self.bubbleView.rightAnchor] setActive:YES];
    [[self.massageTextView.heightAnchor constraintEqualToAnchor:self.bubbleView.heightAnchor] setActive:YES];
    
    /* Date Label */
    self.dateLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.dateLabel];
    [self.dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.dateLabel setTextColor:[UIColor grayColor]];
    [self.dateLabel setFont:[UIFont systemFontOfSize:14]];
    
    self.dateLeftAnchor = [self.dateLabel.leftAnchor constraintEqualToAnchor:self.bubbleView.leftAnchor];
    self.dateRightAnchor = [self.dateLabel.rightAnchor constraintEqualToAnchor:self.bubbleView.rightAnchor];
    
    [[self.dateLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor] setActive:YES];
}

@end

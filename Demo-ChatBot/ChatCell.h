//
//  ChatCell.h
//  Demo-ChatBot
//
//  Created by Imac  on 08/11/19.
//  Copyright © 2019 Global Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGB(r, g, b) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]

NS_ASSUME_NONNULL_BEGIN

@interface ChatCell : UICollectionViewCell

@property (nonatomic, strong) UITextView *massageTextView;
@property (nonatomic, strong) UIView *bubbleView;
@property (nonatomic, strong) NSLayoutConstraint *bubbleWidthAnchor;
@property (nonatomic, strong) NSLayoutConstraint *bubbleRightAnchor;
@property (nonatomic, strong) NSLayoutConstraint *bubbleLeftAnchor;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) NSLayoutConstraint *dateRightAnchor;
@property (nonatomic, strong) NSLayoutConstraint *dateLeftAnchor;

- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END

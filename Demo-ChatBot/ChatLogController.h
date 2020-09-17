//
//  ChatLogController.h
//  Demo-ChatBot
//
//  Created by Imac  on 08/11/19.
//  Copyright © 2019 Global Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatCell.h"
#import <PocketSocket/PSWebSocket.h>
#import "Common.h"

@interface ChatLogController : UICollectionViewController <UICollectionViewDelegateFlowLayout, UITextFieldDelegate, PSWebSocketDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITextField *messageTextField;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) NSLayoutConstraint *containerViewBottomAnchor;
@property (nonatomic, strong) PSWebSocket *webSocket;

+ (ChatLogController *)sharedClass;

@end


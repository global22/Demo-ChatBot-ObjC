//
//  SecondViewController.m
//  Demo-ChatBot
//
//  Created by Imac  on 14/11/19.
//  Copyright © 2019 Global Corporation. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@property (nonatomic, strong) UICollectionViewFlowLayout * layout;
@property (nonatomic, strong) ChatLogController *vc;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViewComponents];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.vc = [[ChatLogController sharedClass] initWithCollectionViewLayout:self.layout];
}

- (void)setupViewComponents {
    [[self navigationItem] setTitle:@"Second"];
    
    SWRevealViewController *revealController = self.revealViewController;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImage *image = [[UIImage imageNamed:@"chat"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleChat)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:revealController
                                                                            action:@selector(revealToggle:)];
}

- (void)handleChat {
    [self.navigationController pushViewController:self.vc
                                         animated:YES];
}

@end

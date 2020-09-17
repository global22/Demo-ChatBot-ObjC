//
//  HomeViewController.m
//  Demo-ChatBot
//
//  Created by Imac  on 11/11/19.
//  Copyright © 2019 Global Corporation. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@property (nonatomic, strong) UICollectionViewFlowLayout * layout;
@property (nonatomic, strong) ChatLogController *vc;
@property (nonatomic, strong) UINavigationController *navController;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    [self setupViewComponents];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.vc = [[ChatLogController sharedClass] initWithCollectionViewLayout:self.layout];
//    self.vc = [[ChatLogController alloc] initWithCollectionViewLayout:self.layout];

//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:chatState] boolValue]) {
//
//    } else {
//        self.layout = [[UICollectionViewFlowLayout alloc] init];
//        self.vc = [[ChatLogController sharedClass] initWithCollectionViewLayout:self.layout];
//        self.vc = [[ChatLogController alloc] initWithCollectionViewLayout:self.layout];
//        self.navController = [[UINavigationController alloc] initWithRootViewController:self.vc];
//
//        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:chatState];
//    }
}

- (void)setupViewComponents {
    [[self navigationItem] setTitle:@"Home"];
    
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

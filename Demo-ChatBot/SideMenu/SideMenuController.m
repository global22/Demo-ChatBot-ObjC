//
//  SideMenuController.m
//  Demo-ChatBot
//
//  Created by Imac  on 13/11/19.
//  Copyright © 2019 Global Corporation. All rights reserved.
//

#import "SideMenuController.h"

@interface SideMenuController ()

@end

@implementation SideMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView setTableFooterView:[UIView alloc]];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"cellId"];
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    
    NSArray *array = @[@"Principal", @"Dos", @"Tres", @"Cuatro", @"Cinco"];
    NSString *text = array[indexPath.row];
    [cell.textLabel setText:text];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SWRevealViewController *revealControler = self.revealViewController;
    UIViewController *newFrontController = nil;
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    SecondViewController *secondViewController = [[SecondViewController alloc] init];
    NSInteger row = indexPath.row;
    
    switch (row) {
        case 0:
            [revealControler setFrontViewPosition:FrontViewPositionLeft
                                         animated:YES];
            
            newFrontController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
            break;
            
        case 1:
            [revealControler setFrontViewPosition:FrontViewPositionLeft
                                         animated:YES];
            
            newFrontController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
        default:
            break;
    }
    
    [revealControler pushFrontViewController:newFrontController
                                    animated:YES];
}
@end

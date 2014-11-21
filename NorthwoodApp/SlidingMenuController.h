//
//  SlidingMenuController.h
//  SlidingMenuLib
//
//  Created by greyson on 10/19/14.
//  Copyright (c) 2014 Greyson Wright. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidingMenuController : UIViewController <UITabBarControllerDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray *viewControllerObjects;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
//@property (nonatomic, getter = shouldHideMenuButton) BOOL hideMenuButton;
@property NSArray *controllerObjects;
@property BOOL loggedIn;
@property BOOL isChangingView;
@property int selectedIndex;

+(SlidingMenuController*)sharedInstance;
-(void)logout;
-(void)login;
-(void)showLoginView;
-(void)cancelLogin;
-(void)resetMenu;
-(void)setViewControllerObjects:(NSArray *)viewControllerObjects;
-(void)setMainViewController:(UIViewController*)viewController;
-(void)fixMenuButton;
-(void)navMenuButtonTapped;
//+(void)shouldHideMenuButton:(BOOL)shouldHide;
//+(void)resetMenu;

@end


//
//  CustomMenuViewController.m
//  MOVYT
//
//  Created by Sumit Ghosh on 27/05/14.
//  Copyright (c) 2014 Sumit Ghosh. All rights reserved.
//

#import "CustomMenuViewController.h"
#import <objc/runtime.h>
#import "ViewController.h"
#import "AppDelegate.h"
#import "TableCustomCell.h"
#import "SingletonClass.h"


#import "UIImageView+WebCache.h"
#import "ViewController.h"
#import "LogInViewController.h"




@interface CustomMenuViewController ()
{
    NSInteger updateValue;
    
    
}
@property (nonatomic,strong)UITabBar *customTabBar;

@end

@implementation CustomMenuViewController
@synthesize viewControllers = _viewControllers;




#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
   }
-(void)viewDidAppear:(BOOL)animated
{
       [self.menuTableView reloadData];
}

#pragma mark -
-(void) setViewControllers:(NSArray *)viewControllers{
    
    _viewControllers = [viewControllers copy];
    
    for (UIViewController *viewController in _viewControllers ) {
        [self addChildViewController:viewController];
        
        viewController.view.frame = CGRectMake(0, 90,[UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-140);
        [viewController didMoveToParentViewController:self];
    }
}
-(void) setSecondSectionViewControllers:(NSArray *)secondSectionViewControllers{
    
    _secondSectionViewControllers = [secondSectionViewControllers copy];
    
    for (UIViewController *viewController in _secondSectionViewControllers ) {
        [self addChildViewController:viewController];
        
        viewController.view.frame = CGRectMake(0, 90,[UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-90);
        [viewController didMoveToParentViewController:self];
    }
}
-(void) setSelectedViewController:(UIViewController *)selectedViewController{
    _selectedViewController = selectedViewController;
}

-(void) setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
}

-(NSArray *) getAllViewControllers{
    return self.viewControllers;
}
-(void) setSelectedSection:(NSInteger)selectedSection{
    _selectedSection = selectedSection;
}

#pragma mark-

-(void)reloadAccountTbl{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadData" object:nil];
    [self.accountTableView reloadData];
    
}
-(void)changeHeaderImg{
    
    
    NSURL * url=[NSURL URLWithString:[SingletonClass shareSinglton].profileImgStr];
    NSData * data=[NSData dataWithContentsOfURL:url];
    
    [self.profileImage setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    
    
    
}

#pragma mark -
- (void)viewDidLoad
{
    
    menuImages=[NSArray arrayWithObjects:@"user_profile.png",@"company_profile.png",@"share.png",@"company_update.png", nil];
    
    windowSize=[UIScreen mainScreen].bounds.size;
    [super viewDidLoad];
    self.dict=[NSMutableDictionary dictionary];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadAccountTbl) name:@"reloadData" object:nil];
    
    screenSize = [UIScreen mainScreen].bounds;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    userDefault = [NSUserDefaults standardUserDefaults];
    
    // Do any additional setup after loading the view.
    
    self.screen_height = [UIScreen mainScreen].bounds.size.height;
    self.isSignIn = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMenuTable:) name:@"UpdateMenuTable" object:nil];
    
    //Add View SubView;
    self.mainsubView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.screen_height-45)];
    NSLog(@"Main sub view frame X=-=- %f \n Y == %f",[UIScreen mainScreen].bounds.origin.x,[UIScreen mainScreen].bounds.origin.y);
    self.mainsubView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainsubView];
    
    //Add Header View
    CGFloat hh;
    CGRect frame_b;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        hh = 75;
        frame_b = CGRectMake(680, 30, 45, 25);
        
    }
    else{
        hh = 55;
        
        frame_b = CGRectMake(20, 20, 45, 25);
    }
    CGRect frame = CGRectMake(0, 0, screenSize.size.width, hh);
    
    self.headerView = [[UIView alloc] initWithFrame:frame];
    self.headerView.backgroundColor =[UIColor colorWithRed:55.0f/255.0f green:105.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    [self.mainsubView addSubview:self.headerView];
    
    NSLog(@"Width menu== %f",screenSize.size.width);
    
    self.headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, screenSize.size.width-120, 25)];
    self.headerTitleLabel.backgroundColor = [UIColor clearColor];
    self.headerTitleLabel.textColor = [UIColor whiteColor];
    self.headerTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.headerTitleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.headerView addSubview:self.headerTitleLabel];
    
    //=======================================
    // Add Container View
    frame = CGRectMake(0,55, screenSize.size.width, screenSize.size.height-55);
    self.contentContainerView = [[UIView alloc] initWithFrame:frame];
    self.contentContainerView.backgroundColor = [UIColor grayColor];
    self.contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.mainsubView addSubview:self.contentContainerView];
    //------------------
    
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton.frame = frame_b;
    self.menuButton.titleLabel.font = [UIFont systemFontOfSize:9.0f];
    self.menuButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [self.menuButton addTarget:self action:@selector(menuButtonClciked:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuButton setBackgroundImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
    
    [self.headerView addSubview:self.menuButton];
    
    self.profileImage = [UIButton buttonWithType:UIButtonTypeCustom];
    self.profileImage.frame = CGRectMake(windowSize.width-60, 15, 30, 30);
    self.profileImage.layer.cornerRadius=self.profileImage.frame.size.width/2;
    self.profileImage.clipsToBounds=YES;
    

    NSURL * url=[NSURL URLWithString:[SingletonClass shareSinglton].userProImg];
    NSData * data=[NSData dataWithContentsOfURL:url];
    
    [self.profileImage setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    [self.headerView addSubview:self.profileImage];
    
    //===================================
    
    //Add Menu Lable
    self.menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 15, 100, 30)];
    self.menuLabel.backgroundColor = [UIColor clearColor];
    self.menuLabel.font = [UIFont boldSystemFontOfSize:15];
    self.menuLabel.textColor = [UIColor whiteColor];
    self.menuLabel.textAlignment = NSTextAlignmentCenter;
    self.menuLabel.text = _selectedViewController.title;
    [self.headerView addSubview:self.menuLabel];
    
    //====================================
    
    self.selectedIndex = 0;
    self.selectedViewController = [_viewControllers objectAtIndex:0];
    [self updateViewContainer];
    [self createMenuTableView];
    [self createAccountTable];
    //Adding Swipr Gesture
        self.swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureLeft:)];
    self.swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.mainsubView addGestureRecognizer:self.swipeGestureLeft];
    //===============
    self.swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureRight:)];
    self.swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.mainsubView addGestureRecognizer:self.swipeGestureRight];
    //-------------
    
    
   
}
#pragma mark -
#pragma mark -Create Table
//create Account Table
-(void)createAccountTable
{
    if (!self.accountTableView)
    {
        self.selectedIndex = 0;
        self.accountTableView = [[UITableView alloc] initWithFrame:CGRectMake(screenSize.size.width-160, 55,180, self.screen_height-140) style:UITableViewStylePlain];
        
        
        self.accountTableView.backgroundColor =[UIColor whiteColor];
        
        self.accountTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.accountTableView.delegate = self;
        self.accountTableView.dataSource = self;
        
    }
    else
    {
        [self.accountTableView reloadData];
    }
    
    [self.view insertSubview:self.accountTableView belowSubview:self.mainsubView];
    
    UIView * viewLogo=[[UIView alloc]init];
    viewLogo.frame=CGRectMake(screenSize.size.width-160, 0, 180, 55);
    viewLogo.backgroundColor=[UIColor colorWithRed:55.0f/255.0f green:105.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    
    [self.view insertSubview:viewLogo belowSubview:self.mainsubView];
    
    UILabel * acounts=[[UILabel alloc]initWithFrame:CGRectMake(25, 10, 120, 50)];
    acounts.text=@"Accounts";
    acounts.font=[UIFont boldSystemFontOfSize:20];
    acounts.textColor=[UIColor whiteColor];
    [viewLogo addSubview:acounts];
    //------------------
    //Add account button.
    UIButton * addAccount=[UIButton buttonWithType:UIButtonTypeCustom];
    addAccount.frame=CGRectMake(screenSize.size.width-150,screenSize.size.height-80 , 100, 25);
    [addAccount setBackgroundImage:[UIImage imageNamed:@"add_account.png"] forState:UIControlStateNormal];
    [addAccount addTarget:self action:@selector(addAccountAction) forControlEvents:UIControlEventTouchUpInside];
    [addAccount setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view insertSubview:addAccount belowSubview:self.mainsubView];
    
    UIButton * logOut=[UIButton buttonWithType:UIButtonTypeCustom];
    logOut.frame=CGRectMake(screenSize.size.width-150,screenSize.size.height-40 , 100, 25);
    [logOut setBackgroundImage:[UIImage imageNamed:@"add_account.png"] forState:UIControlStateNormal];
    [logOut addTarget:self action:@selector(logOutAccountAction:) forControlEvents:UIControlEventTouchUpInside];
    [logOut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   // [self.view insertSubview:logOut belowSubview:self.mainsubView];
    
}
// Add new accounts
-(void)addAccountAction{
    [SingletonClass shareSinglton].fromAddAccount=YES;
    LogInViewController * logVC=[[LogInViewController alloc]initWithNibName:@"LogInViewController" bundle:nil];
    [self presentViewController:logVC animated:YES completion:nil];
     
}



// create menu list Table.
-(void) createMenuTableView
{
    
    if (!self.menuTableView)
    {
        self.selectedIndex = 0;
        self.menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,55,180, self.screen_height-140) style:UITableViewStylePlain];
        self.menuTableView.backgroundColor=[UIColor whiteColor];
        self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.menuTableView.delegate = self;
        self.menuTableView.dataSource = self;
        self.menuTableView.backgroundColor=[UIColor clearColor];
    }
    else
    {
        [self.menuTableView reloadData];
    }
    
    [self.view insertSubview:self.menuTableView belowSubview:self.mainsubView];
    UIView * viewLogo=[[UIView alloc]init];
    viewLogo.frame=CGRectMake(0, 0, 140, 55);
    viewLogo.backgroundColor=[UIColor colorWithRed:55.0f/255.0f green:105.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    [self.view insertSubview:viewLogo belowSubview:self.mainsubView];
    
}

#pragma mark -
#pragma mark -
// handle sqipe gesture here.
-(void)handleSwipeGestureRight:(UISwipeGestureRecognizer *)swipeGesture
{
    
    if (self.mainsubView.frame.origin.x==0) {
        
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(140, 0,screenSize.size.width, screenSize.size.height-45);
        }completion:^(BOOL finish){
        }];
    }
    else
    {
        
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(0, 0,screenSize.size.width, screenSize.size.height-45);
            
        }completion:^(BOOL finish){
            
            self.swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
        }];
    }
}
-(void)handleSwipeGestureLeft:(UISwipeGestureRecognizer *)swipeGesture
{
    if (self.mainsubView.frame.origin.x==0)
    {
        
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(-160, 0,screenSize.size.width, screenSize.size.height-45);
        }completion:^(BOOL finish){
        }];
        
    }
    else
    {
        
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(0, 0,screenSize.size.width, screenSize.size.height-45);
            
        }completion:^(BOOL finish){
            
        }];
    }
}
#pragma mark -
//handle menu button to show menu list.
-(void) menuButtonClciked:(id)sender
{
    
    if (self.mainsubView.frame.origin.x>=120) {
        
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(-0, 0,screenSize.size.width, screenSize.size.height-45);
            
        }completion:^(BOOL finish){
            
            self.swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
        }];
    }
    else{
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(140, 0,screenSize.size.width, screenSize.size.height-45);
        }completion:^(BOOL finish){
            self.swipeGestureRight.direction = UISwipeGestureRecognizerDirectionLeft;
        }];
    }
    
    
}

#pragma mark -
#pragma mark TableView Delegate and DataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.menuTableView)
    {
    if (section==0) {
        
        return self.viewControllers.count;
    }
    else if (section == 1){
        return self.secondSectionViewControllers.count;
    }
    }
    else if (tableView==self.accountTableView)
    {
        return [SingletonClass shareSinglton].allData.count;
    }
    return 0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"menuTable";
    
    TableCustomCell *cell = (TableCustomCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[TableCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //Check Section
    if(tableView==self.menuTableView)
    {
    NSString * title=[NSString stringWithFormat:@"%@",[(UIViewController *)[_viewControllers objectAtIndex:indexPath.row] title]];
    NSLog(@"Title = %@",title);
    
        cell.cellMenuTitle.text=title;
        cell.cellMenuTitle.font=[UIFont systemFontOfSize:14];
        
        cell.menuImages.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[menuImages objectAtIndex:indexPath.row]]];
        
    }
    else if(tableView==self.accountTableView)
    {

        
        cell.settingButton.tag=indexPath.row;
        
        self.dict=[[SingletonClass shareSinglton].allData objectAtIndex:indexPath.row];
        NSString * name=[self.dict objectForKey:@"userFullName"];
        cell.cellTitle.text=name;
        cell.cellTitle.numberOfLines=0;
        cell.cellTitle.lineBreakMode=NSLineBreakByCharWrapping;
        cell.cellTitle.font=[UIFont systemFontOfSize:12];
        
       NSURL * url=[self.dict objectForKey:@"profilePic"];
        [cell.profileImg sd_setImageWithURL:url];

        
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.menuTableView) {
        
    
    
    //Dismiss Menu TableView with Animation
    [UIView animateWithDuration:.5 animations:^{
        
        self.mainsubView.frame = CGRectMake(0, 0, screenSize.size.width, screenSize.size.height-45);
        
    }completion:^(BOOL finished){
        //After completion
        //first check if new selected view controller is equals to previously selected view controller
        UIViewController *newViewController = [_viewControllers objectAtIndex:indexPath.row];
        if ([newViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)newViewController popToRootViewControllerAnimated:YES];
        }
        
        if (indexPath.row==0) {
            
            self.customTabBar.selectedItem = [self.customTabBar.items objectAtIndex:0];
        }
        if (indexPath.row==1) {
            
            self.customTabBar.selectedItem = [self.customTabBar.items objectAtIndex:1];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loadFollowing" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loadFollowing" object:nil];
        }
        if (indexPath.row==2) {
            self.customTabBar.selectedItem = [self.customTabBar.items objectAtIndex:2];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loadShare" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loadShare" object:nil];
            
            
           
        }
        if (indexPath.row==3) {
            
            self.customTabBar.selectedItem = [self.customTabBar.items objectAtIndex:3];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loadCompany" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loadCompany" object:nil];
        }
        


        _selectedSection = indexPath.section;
        _selectedIndex = indexPath.row;
        
        [self getSelectedViewControllers:newViewController];
        updateValue = 0;
    }];
    }
    else{
        
        
        //Dismiss Menu TableView with Animation
        [UIView animateWithDuration:.5 animations:^{
            
            self.mainsubView.frame = CGRectMake(0, 0, screenSize.size.width, screenSize.size.height-45);
            
        }completion:^(BOOL finished){
            //After completion
            //first check if new selected view controller is equals to previously selected view controller
            UIViewController *newViewController = [_viewControllers objectAtIndex:0];
            if ([newViewController isKindOfClass:[UINavigationController class]]) {
                [(UINavigationController *)newViewController popToRootViewControllerAnimated:YES];
            }
        
            
            if (selectedUser) {
                selectedUser=nil;
            }
            selectedUser=[NSMutableDictionary dictionary];
            selectedUser=[[SingletonClass shareSinglton].allData objectAtIndex:indexPath.row];
            [[NSUserDefaults standardUserDefaults]setObject:[selectedUser objectForKey:@"accessToken"] forKey:@"access_token"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [SingletonClass shareSinglton].profileImgStr=[selectedUser objectForKey:@"profilePic"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loadProfile" object:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loadProfile" object:nil];
          
            [self changeHeaderImg];
            
            
            _selectedSection = indexPath.section;
            _selectedIndex = indexPath.row;
            
            [self getSelectedViewControllers:newViewController];
            updateValue = 0;
        }];
        
        
    }
    self.topicButton.hidden=YES;
    
}



#pragma mark -
-(void) getSelectedViewControllers:(UIViewController *)newViewController{
    // selected new view controller
    UIViewController *oldViewController = _selectedViewController;
    
    if (newViewController != nil) {
        [oldViewController.view removeFromSuperview];
        _selectedViewController = newViewController;
        
        //Update Container View with selected view controller view
        [self updateViewContainer];
        //Check Delegate assign or not
    }
}

// update selected viewcontroller
-(void) updateViewContainer
{
    self.selectedViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    self.selectedViewController.view.frame = self.contentContainerView.bounds;
    NSLog(@"menu label -=- %@",self.menuLabel.text);
    self.headerTitleLabel.text=self.self.selectedViewController.title;
    [self.contentContainerView addSubview:self.selectedViewController.view];
    
}

-(void)logOutAccountAction:(UIButton *)sender{
    
   
    [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteRowofSelectedUser" object:nil];
}



#pragma mark-----
@end

static void * const kMyPropertyAssociatedStorageKey = (void*)&kMyPropertyAssociatedStorageKey;

@implementation UIViewController (CustomMenuViewControllerItem)
@dynamic customMenuViewController;

static char const * const orderedElementKey;

-(void) setCustomMenuViewController:(CustomMenuViewController *)customMenuViewController{
    
    NSLog(@"cc==%@",customMenuViewController.viewControllers);
    
    objc_setAssociatedObject(self, &orderedElementKey, customMenuViewController,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CustomMenuViewController *) customMenuViewController{
    
    if (objc_getAssociatedObject(self, &orderedElementKey) != nil)
    {
        NSLog(@"Element: %@", objc_getAssociatedObject(self, orderedElementKey));
    }
    
    NSLog(@"Element: %@", objc_getAssociatedObject(self, &orderedElementKey));
    //    return objc_getAssociatedObject(self, @selector(customMenuViewController));
    return objc_getAssociatedObject(self, orderedElementKey);
    //return  self.customMenuViewController;
}

@end

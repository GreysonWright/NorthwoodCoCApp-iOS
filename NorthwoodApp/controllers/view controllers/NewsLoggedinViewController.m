//
//  NewsLoggedinViewController.m
//  NorthwoodCoC
//
//  Created by greyson on 6/16/14.
//  Copyright (c) 2014 Greyson Wright. All rights reserved.
//

#import "AppDelegate.h"
#import "NewsLoggedinViewController.h"
#import "TFHpple.h"
#import "Bulletin.h"
#import "BulletinTableViewCell.h"
#import "PrayerList.h"
#import "PrayerListTableViewCell.h"
#import "DutyRoster.h"
#import "DutyRosterTableViewCell.h"
#import "LogginginViewController.h"
#import "Directory.h"
#import "DirectoryTableViewCell.h"
#import "UniversalWebViewViewController.h"
#import "SettingsViewController.h"
#import "HomeViewController.h"
#import "NetworkStatus.h"
#import "ASIHTTPRequest.h"

@interface NewsLoggedinViewController (){
	NSMutableArray *_bulletinObjects;
	NSMutableArray *_bareBulletinObjects;
	NSMutableArray *_bulletinPDFs;
	NSMutableArray *_prayerListObjects;
	NSMutableArray *_dutyRosterObjects;
	NSMutableArray *_nameObjects;
	NSMutableArray *_titleObjects;
	NSMutableArray *_phoneObjects;
	NSMutableArray *_emailObjects;
	NSMutableArray *_addressObjects;
	NSMutableArray *_linksForWebView;
	NSString *_bulletinEndURL;
	int _selectedSegment;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property UIRefreshControl* refreshControl;

@end

@implementation NewsLoggedinViewController
static BOOL loggedin;
BOOL offlineMode;

-(void)loadStuff{
	if([NetworkStatus networkExists]){
		dispatch_async(dispatch_get_main_queue(), ^{
			if(_selectedSegment == 0){
				_bulletinObjects = nil;
				_linksForWebView = nil;
				_bulletinObjects = [Bulletin bulletinObject];
				_linksForWebView = [Bulletin bulletinLink];
			}
			else if(_selectedSegment == 1){
				_prayerListObjects = nil;
				_prayerListObjects = [PrayerList prayerListObjects];
			}
			
			else if(_selectedSegment == 2){
				_dutyRosterObjects = nil;
				_dutyRosterObjects = [DutyRoster dutyRosterObjects];
			}
			
			else if(_selectedSegment == 3){
				_nameObjects = nil;
				_titleObjects = nil;
				_phoneObjects = nil;
				_emailObjects = nil;
				_addressObjects = nil;
				_nameObjects = [Directory nameObjects];
				_titleObjects = [Directory titleObjects];
				_phoneObjects = [Directory phoneObjects];
				_emailObjects = [Directory emailObjects];
				_addressObjects = [Directory adressObjects];
			}
			[self.refreshControl endRefreshing];
			[self.tableView reloadData];
			offlineMode = NO;
		});
	}
	else{
		NSLog(@"don't refresh");
		[self.refreshControl endRefreshing];
	}
}

-(void)loadEverything{
	if([NetworkStatus networkExists]){
		dispatch_async(dispatch_get_main_queue(), ^{
			_bulletinObjects = nil;
			_linksForWebView = nil;
			_prayerListObjects = nil;
			_dutyRosterObjects = nil;
			_nameObjects = nil;
			_titleObjects = nil;
			_phoneObjects = nil;
			_emailObjects = nil;
			_addressObjects = nil;
			_bulletinObjects = [Bulletin bulletinObject];
			_linksForWebView = [Bulletin bulletinLink];
			_prayerListObjects = [PrayerList prayerListObjects];
			_dutyRosterObjects = [DutyRoster dutyRosterObjects];
			_nameObjects = [Directory nameObjects];
			_titleObjects = [Directory titleObjects];
			_phoneObjects = [Directory phoneObjects];
			_emailObjects = [Directory emailObjects];
			_addressObjects = [Directory adressObjects];
			[self.refreshControl endRefreshing];
			[self.tableView reloadData];
			offlineMode = NO;
		});
	}
	else{
		NSLog(@"don't refresh");
		[self.refreshControl endRefreshing];
	}
}

- (IBAction)segmentsChanged:(id)sender {
	_selectedSegment = self.segmentController.selectedSegmentIndex;
	[self.tableView reloadData];
	[self.tableView scrollRectToVisible:CGRectMake(0, 0, 320, 125) animated:NO];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		_bulletinObjects = [[NSMutableArray alloc]init];
		_bareBulletinObjects = [[NSMutableArray alloc]init];
		_bulletinPDFs = [[NSMutableArray alloc]init];
		_prayerListObjects = [[NSMutableArray alloc]init];
		_dutyRosterObjects = [[NSMutableArray alloc]init];
		_nameObjects = [[NSMutableArray alloc]init];
		_titleObjects = [[NSMutableArray alloc]init];
		_phoneObjects = [[NSMutableArray alloc]init];
		_emailObjects = [[NSMutableArray alloc]init];
		_addressObjects = [[NSMutableArray alloc]init];
		_linksForWebView = [[NSMutableArray alloc]init];
		
		
		if([NetworkStatus networkExists]){
			_bulletinObjects = [Bulletin bulletinObject];
			_bareBulletinObjects = [Bulletin getBareBulletinObjects];
			_bulletinPDFs = [Bulletin getBulletinPDF];
			_linksForWebView = [Bulletin bulletinLink];
			_prayerListObjects = [PrayerList prayerListObjects];
			_dutyRosterObjects = [DutyRoster dutyRosterObjects];
			_nameObjects = [Directory nameObjects];
			_titleObjects = [Directory titleObjects];
			_phoneObjects = [Directory phoneObjects];
			_emailObjects = [Directory emailObjects];
			_addressObjects = [Directory adressObjects];
			
			[[NSUserDefaults standardUserDefaults]setObject:_bareBulletinObjects forKey:@"bareBulletinObjects"];
			[[NSUserDefaults standardUserDefaults]setObject:_bulletinPDFs forKey:@"bulletinPDFs"];
			[[NSUserDefaults standardUserDefaults]synchronize];
			offlineMode = NO;
		}
		else if(![NetworkStatus networkExists]){
			_bareBulletinObjects = [[NSUserDefaults standardUserDefaults]objectForKey:@"bareBulletinObjects"];
			_bulletinPDFs = [[NSUserDefaults standardUserDefaults]objectForKey:@"bulletinPDFs"];
			offlineMode = YES;
		}
		
		self.title=@"Members";
		self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle: @"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(settingsTitleButtonTapped)];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:YES];
	loggedin = [[NSUserDefaults standardUserDefaults]boolForKey:@"loggedIn"];
	if(loggedin == NO){
		self.segmentController.selectedSegmentIndex = 0;
		_selectedSegment = 0;
		LogginginViewController *logginView = [[LogginginViewController alloc]init];
		[self presentViewController:logginView animated:YES completion:nil];
	}
	else if(loggedin == YES){
		self.navigationItem.title = [@"Hi, " stringByAppendingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
	}
}

-(void)viewDidAppear:(BOOL)animated{
	
	if(loggedin == YES && [self needsToReload])
		self.navigationItem.title = [@"Hi, " stringByAppendingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
	
	if([self needsToReload])
		if([NetworkStatus networkExists])
			dispatch_async(dispatch_get_main_queue(), ^{
				[self loadEverything];
			});
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, -60, self.tableView.frame.size.width, 60)];
    [self.refreshControl addTarget:self action:@selector(loadStuff) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
	self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle: @"logout" style:UIBarButtonItemStylePlain target:self action:@selector(logoutTitleButtonTapped)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger returnThis;
	if(_selectedSegment == 0 && !offlineMode){
		returnThis = _bulletinObjects.count;
	}
	else if(_selectedSegment == 0 && offlineMode){
		returnThis = _bareBulletinObjects.count;
	}
	else if(_selectedSegment == 1){
		returnThis = 1;
	}
	else if(_selectedSegment == 2){
		returnThis = 1;
	}
	else if (_selectedSegment == 3 && !offlineMode){
		returnThis = _nameObjects.count;
	}
	/*else if(_selectedSegment == 3 && offlineMode){
		
	}*/
    return returnThis;
}

- (CGFloat)tableView:(UITableView *)tableview heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	int returnThis;
	if(_selectedSegment == 0){
		returnThis = 73;
	}
	else if(_selectedSegment == 1){
		returnThis = 700;
	}
	else if(_selectedSegment == 2){
		returnThis = 700;
	}
	else if (_selectedSegment == 3){
		returnThis = 109;
	}
	return returnThis;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if(_selectedSegment == 0){
		UniversalWebViewViewController *webView= [[UniversalWebViewViewController alloc]init];
		[webView loadBulletinPDF:[_linksForWebView objectAtIndex:indexPath.row]];
		[self.navigationController pushViewController:webView animated:YES];//not doing this anymore gonna download pdfs instead hopefully
		NSLog(@"linksforwebview %d",_linksForWebView.count);
		NSLog(@"_bulletinobjects %d", _bulletinObjects.count);
	}
	else if(_selectedSegment == 1){
		NSLog(@"do nothing");
	}
	else if(_selectedSegment == 2){
		NSLog(@"do nothing");
	}
	else if (_selectedSegment == 3){
		NSLog(@"do nothing");
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *returnThis;
	
	if(_selectedSegment == 0){ //bulletins
			
		BulletinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BulletinCell"];
		
		if (cell == nil) {
			cell = [[BulletinTableViewCell alloc] init];
		}
		if(!offlineMode){
			Bulletin *thisBulletin = [_bulletinObjects objectAtIndex:indexPath.row];
			[cell fillWithData:thisBulletin];
		}
		else if(offlineMode){
			[cell fillWithBareData:[_bareBulletinObjects objectAtIndex:indexPath.row]];
		}
		
		returnThis = cell;
	}
	
	else if(_selectedSegment == 1){ //prayerlist
		PrayerListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrayerListCell"];
		if (cell==nil) {
			cell = [[PrayerListTableViewCell alloc] init];
		}
		if(!offlineMode){
			PrayerList *thisPrayerList = [_prayerListObjects objectAtIndex:indexPath.row];
			[cell fillWithData:thisPrayerList];
		}
		else if(offlineMode){
			[cell loadWebPageInOfflineMode];
		}
		returnThis = cell;
	}
	
	else if(_selectedSegment == 2){//roster
		DutyRosterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DutyRosterCell"];
		if (cell==nil) {
			cell = [[DutyRosterTableViewCell alloc] init];
		}
		if(!offlineMode){
			DutyRoster *thisDutyRoster = [_dutyRosterObjects objectAtIndex:indexPath.row];
			[cell fillWithData:thisDutyRoster];
		}
		else if(offlineMode){
			[cell loadWebPageInOfflineMode];
		}
		returnThis = cell;
	}
	
	else if (_selectedSegment == 3){//directory
		DirectoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DirectoryCell"];
		Directory *thisName = [_nameObjects objectAtIndex:indexPath.row];
		Directory *thisTitle = [_titleObjects objectAtIndex:indexPath.row];
		Directory *thisPhone = [_phoneObjects objectAtIndex:indexPath.row];
		Directory *thisEmail = [_emailObjects objectAtIndex:indexPath.row];
		Directory *thisAddress = [_addressObjects objectAtIndex:indexPath.row];
		if (cell == nil) {
			cell = [[DirectoryTableViewCell alloc] init];
		}
		[cell fillNameWithData:thisName];
		[cell fillTitleWithData:thisTitle];
		[cell fillPhoneWithData:thisPhone];
		[cell fillEmailWithData:thisEmail];
		[cell fillAddressWithData:thisAddress];
		
		returnThis = cell;
	}
	
    return returnThis;
}

+(void)setLoggedin:(BOOL)newLoggedin{
	loggedin = newLoggedin;
	[[NSUserDefaults standardUserDefaults]setBool:newLoggedin forKey:@"loggedIn"];
	[[NSUserDefaults standardUserDefaults]synchronize];
}

+(BOOL)getLoggedin{
	return loggedin;
}

-(void)logoutTitleButtonTapped{
	UIAlertView *loggoutWarning = [[UIAlertView alloc]initWithTitle:@"logout?" message:@"Are you sure you would like to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles: @"Yes", nil];
    [loggoutWarning show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex == 0){
		NSLog(@"User cancelled logout");
	}
	else{
		[alertView dismissWithClickedButtonIndex:-1 animated:YES];
		loggedin = NO;
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loggedIn"];
		[[NSUserDefaults standardUserDefaults] setObject:@"Members" forKey:@"username"];
		[[NSUserDefaults standardUserDefaults]synchronize];
		AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
		appDelegate.tabBar.selectedIndex=0;
		[self.tableView reloadData];
	}
}

-(void)settingsTitleButtonTapped{
	SettingsViewController *settingsView = [[SettingsViewController alloc]init];
	[self.navigationController pushViewController:settingsView animated:YES];
}

-(BOOL)needsToReload{
	if(_bulletinObjects.count == 0 || _prayerListObjects.count == 0 || _dutyRosterObjects.count == 0 || _titleObjects.count == 0){
		NSLog(@"reload");
		return YES;
	}
	else{
		NSLog(@"doesnt need to reload");
		return NO;
	}
}
@end
//
//  CCTelDetailViewController.m
//  XidianNavigation
//
//  Created by ooops on 13-3-21.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import "CCTelDetailViewController.h"
#import "CCTelSearchViewController.h"
#import "MBHUDView.h"

@interface CCTelDetailViewController ()
- (NSArray *)splitTelephoneNumber:(NSString *)sender;
- (NSString *)trimPhoneNumber:(NSString *)number;
- (void)switchToSearchView;
@end

@implementation CCTelDetailViewController

@synthesize  Dpid, datalist, Dname, commonlist;

- (void)getData
{
    
        [ApplicationDelegate.telEngine getJSONFrom:[NSString stringWithFormat:@"ios/search.php?Dpid=%d", Dpid]
                                 completionHandler:^(id InfoTitles) {
                                     
                                     self.datalist = InfoTitles;
                                     [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];
                                     
                                 } errorHandler:^(NSError *error) {
                                     [self doneLoadingTableViewData];
                                     [self showNetworkErrorNotifier];
                                 }];
    

}

- (void)switchToSearchView
{
    CCTelSearchViewController *searchViewController = [[CCTelSearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:YES];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.Dname;
    
    self.navigationItem.leftBarButtonItem =  nil;
    
    self.tableView.separatorColor = [UIColor colorWithHexColor:@"#3ba3d0" alpha:.4];

    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:PathInMainBundle(@"navbar_tel_search", kPNGFileType)] style:UIBarButtonItemStylePlain target:self action:@selector(switchToSearchView)];
    self.navigationItem.rightBarButtonItem = searchButton;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.commonlist == nil) {
        [self getData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.commonlist == nil) {
    return [self.datalist count];
    }
    
    return [[self.commonlist allValues] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TelDetailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if (self.commonlist == nil) {
        NSDictionary *cellContent = [self.datalist objectAtIndex:indexPath.row];
        cell.textLabel.text = [cellContent objectForKey:@"Pname"];
        cell.detailTextLabel.text = [cellContent objectForKey:@"Pnum"];
    } else {
        cell.textLabel.text = [[self.commonlist allKeys] objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [[self.commonlist allValues] objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumFontSize = 8.0f;
    cell.textLabel.textColor = [UIColor colorWithWhite:.2 alpha:1];
    
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.minimumFontSize = 6.0f;
//    cell.detailTextLabel.textColor = [UIColor colorWithRed:0 green:0.62 blue:0.88 alpha:1.0];
    
    
    
    cell.backgroundColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1];


//    UIColor *whiteColor = [UIColor whiteColor];
//    CGSize shadowOffset = CGSizeMake(0, 1);
//    
//    [[UILabel appearanceWhenContainedIn:[UITableViewCell class], nil] setShadowColor:whiteColor];
//    [[UILabel appearanceWhenContainedIn:[UITableViewCell class], nil] setShadowOffset:shadowOffset];

    
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:PathInMainBundle(@"tel_cell_image", kPNGFileType)]];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSArray *numbers = nil;
    if (commonlist == nil) {

        NSDictionary *cellContent = [self.datalist objectAtIndex:indexPath.row];
        numbers = [self splitTelephoneNumber:[cellContent objectForKey:@"Pnum"]];
    } else {
        numbers = [self splitTelephoneNumber:[[self.commonlist allValues] objectAtIndex:indexPath.row]];
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.title = @"请选择";
    actionSheet.delegate = self;
    NSInteger index = 0;
    for (NSString *number in numbers) {
        NSString *title = [NSString stringWithFormat:
                           ([number rangeOfString:@"QQ"].location == NSNotFound) ? @"拔打 %@":  @"%@", number];
        [actionSheet addButtonWithTitle:title];
        ++index;
    }
    [actionSheet addButtonWithTitle:@"取消"];
    actionSheet.destructiveButtonIndex = 0;
    actionSheet.cancelButtonIndex = index;
    
    [actionSheet showInView:self.view];
    
}


#pragma mark - Custom Methods

- (NSArray *)splitTelephoneNumber:(NSString *)sender
{
    NSCharacterSet *separators = [NSCharacterSet characterSetWithCharactersInString:@"/／、,， "];
    NSArray *components = [sender componentsSeparatedByCharactersInSet:separators];
    NSMutableArray *validComponents = [[NSMutableArray alloc] initWithCapacity:[components count]];

    for (NSString *component in components) {

        if (component.length) {

            [validComponents addObject:component];

        }
    }
    return validComponents;
}

- (NSString *)trimPhoneNumber:(NSString *)number
{
//    NSString *pattern =
//    @"(!(QQ).{0,5}\\s*(\\d{3})?\\s*[-－]{0,2}\\s*\\d{8}\\s*[-－]{0,2}(\\d{3})?)|(\\d{11})|((\\d{3})?\\s*[-－]{0,2}\\s*\\d{3,4}\\s*[-－]{0,2}\\s*\\d{3,4})";
    NSString *pattern = @"([qQ]{2}(\\s{0,2})[:：]?\\2\\d{6,11})|(\\d{11})|((\\d{3})?[-－]{0,2}\\d{3,4}[-－]{0,2}\\d{3,4})|(\\d{5})";
    NSError *error = nil;
    
    NSRegularExpression *numberRegex =
    [NSRegularExpression regularExpressionWithPattern:pattern
                                              options:NSRegularExpressionCaseInsensitive
                                                error:&error];
    NSRange range =[numberRegex rangeOfFirstMatchInString:number options:0 range:NSMakeRange(0, [number length])];
    
    if (range.length) {
        NSString *numberToReturn = [number substringWithRange:range];
        NSRange rangeOfBitch = [numberToReturn rangeOfString:@"－"];
        if (rangeOfBitch.location != NSNotFound) {
            NSMutableString *notRightNumber = [NSMutableString stringWithString:numberToReturn];
            [notRightNumber replaceCharactersInRange:rangeOfBitch withString:@"-"];
            return notRightNumber;
        }
        return [number substringWithRange:range];
    }
    
    return nil;
    
}


#pragma mark - Action Sheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        NSString *numberToCall = [self trimPhoneNumber:title];
        if ([numberToCall rangeOfString:@"qq" options:NSCaseInsensitiveSearch].location == NSNotFound) {
            
            NSURL *numberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", numberToCall]];
            [[UIApplication sharedApplication] openURL:numberURL];
            
        } else {
            
            MBAlertView *alert = [MBAlertView alertWithBody:@"亲，QQ号码可不能拨打哦~" cancelTitle:nil cancelBlock:nil];
            [alert addButtonWithText:@"好的" type:MBAlertViewItemTypePositive block:nil];
            [alert addToDisplayQueue];
        }
    }
}

@end

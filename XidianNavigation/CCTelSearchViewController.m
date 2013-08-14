//
//  CCTelSearchViewController.m
//  XidianNavigation
//
//  Created by ooops on 13-3-27.
//  Copyright (c) 2013年 http://ooopscc.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CCTelSearchViewController.h"
#import "CCTelViewController.h"
#import "MBHUDView.h"

@interface CCTelSearchViewController ()
- (void)getData:(NSString *)sender;
@end

@implementation CCTelSearchViewController

@synthesize searchResult;
@synthesize searchBar, tableview, dimView;

- (void)getData:(NSString *)sender
{
    NSString *searchText = [NSString stringWithFormat:@"ios/search.php?keyword=%@", (NSString *)sender];
    searchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ApplicationDelegate.telEngine getJSONFrom:searchText
                             completionHandler:^(id InfoTitles) {
                                 
                                 self.searchResult = InfoTitles;
                                 [self.tableview reloadData];
                                 
                             } errorHandler:^(NSError *error) {
                                 
                             }];
}

- (IBAction)hideKeyboard
{
    [self.searchBar resignFirstResponder];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"电话搜索";
    
    self.tableview.separatorColor = [UIColor colorWithHexColor:@"#3ba3d0" alpha:.4];
    
    [self.searchBar becomeFirstResponder];

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
    if ([self.searchResult count]) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.searchResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"Pname"];
    cell.detailTextLabel.text = [[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"Pnum"];
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumFontSize = 8.0f;
    cell.textLabel.textColor = [UIColor colorWithWhite:.2 alpha:1];
    
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.minimumFontSize = 6.0f;

    
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
    NSArray *numbers = [self splitTelephoneNumber:[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"Pnum"]];
    
    
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEWFRAMESIZE.width, 22)];
    headerView.backgroundColor = [UIColor colorWithRed:0 green:0.62 blue:0.88 alpha:1.0];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 22)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.shadowColor = [UIColor colorWithWhite:0.4 alpha:1];
    titleLabel.shadowOffset = CGSizeMake(0, 1);
    NSString *headerText = self.searchBar.text ? [NSString stringWithFormat:@"\"%@\" 的搜索结果", self.searchBar.text] : @"搜索结果";
    titleLabel.text = headerText;//@"搜索结果";
    
    [headerView addSubview:titleLabel];
    
    return headerView;
}


#pragma mark - Search Bar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchText = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([searchText length] == 0) {
        return;
    }
    [self getData:searchText];
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 0.25f;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.navigationController.view.layer.position.x, self.navigationController.view.layer.position.y);
    CGPathAddLineToPoint(path, NULL, self.navigationController.view.layer.position.x, self.navigationController.view.layer.position.y + self.searchBar.bounds.size.height);
    positionAnimation.path = path;
    CGPathRelease(path);
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [self.navigationController.view.layer addAnimation:positionAnimation forKey:@"moveSearchBar"];
    
    self.navigationController.view.center = CGPointMake(self.navigationController.view.center.x, self.navigationController.view.center.y + self.searchBar.bounds.size.height);
    
    [self.searchBar setShowsCancelButton:NO animated:YES];

    [self hideKeyboard];
    [UIView animateWithDuration:0.25f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.dimView.alpha = 0;
                     } completion:^(BOOL finished) {
                         self.dimView.hidden = YES;
                     }];

}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 0.25f;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.navigationController.view.layer.position.x, self.navigationController.view.layer.position.y);
    CGPathAddLineToPoint(path, NULL, self.navigationController.view.layer.position.x, self.navigationController.view.layer.position.y - self.searchBar.bounds.size.height);
    positionAnimation.path = path;
    CGPathRelease(path);
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [self.navigationController.view.layer addAnimation:positionAnimation forKey:@"moveSearchBar"];
    
    self.navigationController.view.center = CGPointMake(self.navigationController.view.center.x, self.navigationController.view.center.y - self.searchBar.bounds.size.height);
    
    [self.searchBar setShowsCancelButton:YES animated:YES];
    [UIView animateWithDuration:0.25f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.dimView.hidden = NO;
                         self.dimView.alpha = 1;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 0.25f;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.navigationController.view.layer.position.x, self.navigationController.view.layer.position.y);
    CGPathAddLineToPoint(path, NULL, self.navigationController.view.layer.position.x, self.navigationController.view.layer.position.y + self.searchBar.bounds.size.height);
    positionAnimation.path = path;
    CGPathRelease(path);
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [self.navigationController.view.layer addAnimation:positionAnimation forKey:@"moveSearchBar"];
    
    self.navigationController.view.center = CGPointMake(self.navigationController.view.center.x, self.navigationController.view.center.y + self.searchBar.bounds.size.height);
    
    [self.searchBar setShowsCancelButton:NO animated:YES];
    
    [self hideKeyboard];
    [UIView animateWithDuration:0.25f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.dimView.alpha = 0;
                     } completion:^(BOOL finished) {
                         self.dimView.hidden = YES;
                     }];
}

#pragma mark - Scroll View Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hideKeyboard];
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
//    @"(!(QQ).{0,5}\\s*(\\d{3})?\\s*[-－]{0,2}\\s*\\d{8}\\s*[-－]{0,2}(\\d{3})?)|(\\d{11})|(\\d{3}\\s*[-－]{0,2}\\s*\\d{3,4}\\s*[-－]{0,2}\\s*\\d{3,4})";
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


@end

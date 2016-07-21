//
//  CityViewController.m
//  CityWeather
//
//  Created by Luiz Monteiro on 20/07/16.
//  Copyright © 2016 LuizMonteiro. All rights reserved.
//

#import "CityViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "Utils.h"
#import "KGModal.h"

@interface CityViewController ()

@end

@implementation CityViewController
@synthesize coordinates;

#pragma mark - Cycle Life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    UILabel *titleMain = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, 150, 20)];
    titleMain.backgroundColor = [UIColor clearColor];
    titleMain.font = [UIFont fontWithName:@"TrebuchetMS" size:20];
    titleMain.shadowColor = [UIColor darkGrayColor];
    titleMain.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleMain.textColor = APPLEBLUE;
    titleMain.text = @"List Weather";
    titleMain.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleMain];
    
    [titleView sizeToFit];
    
    self.navigationItem.titleView = titleView;
    
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshClick:)];
    self.navigationItem.rightBarButtonItem = refreshItem;
    
    
    
}

-(void)viewDidLayoutSubviews{
    int height;
    
    if (IS_IPHONE_4_OR_LESS) {
        height = 481;
    }else if (IS_IPHONE_5){
        height = 569;
    }else if (IS_IPHONE_6){
        height = 668;
    }else if (IS_IPHONE_6P){
        height = 737;
    }
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, height);
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(void)refreshClick:(id)sender{
    [self getData];
}

#pragma mark - Spinner

- (void)spinnerActivity:(BOOL)enabled{
    if (enabled == YES) {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [spinner sizeToFit];
        [spinner setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
        [spinner setColor:APPLEBLUE];
        
        UIBarButtonItem *loadingView = [[UIBarButtonItem alloc] initWithCustomView:spinner];
        
        self.navigationItem.rightBarButtonItem = loadingView;
        spinner.hidden = NO;
        [spinner startAnimating];
        
    }else{
        UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshClick:)];
        self.navigationItem.rightBarButtonItem = refreshItem;
        /*UIActivityIndicatorView *spinner;
        spinner.hidden = YES;
        [spinner stopAnimating];*/
    }
}

#pragma mark - Connections

-(void)getData{
    
    [self spinnerActivity:YES];
    float lat = self.coordinates.latitude;
    float lon = self.coordinates.longitude;
    NSString *url = [NSString stringWithFormat:FORECAST_URL,lat, lon, APP_ID];
    
    NSLog(@"URL: %@", url);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"Success");
        [self successBlock:responseObject];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self errorBlock:error];
    }];
    
    
}

-(void)successBlock:(NSDictionary *)data{
    NSDictionary *listObj;
    NSDictionary *aux;
    NSArray *arrAux;
    NSString *strAux;
    
    dataSource = [[NSMutableArray alloc] init];
    
    NSArray *list = [data objectForKey:@"list"];
    
    for (int i = 0; i < [list count]; i++) {
        container = [[CityData alloc] init];
        listObj = [list objectAtIndex:i];
        strAux = [listObj objectForKey:@"name"];
        
        [container setCityName:strAux];
        
        aux = [listObj objectForKey:@"main"];
        
        strAux = [aux objectForKey:@"temp_min"];
        [container setCityMinTemp:strAux];
        
        strAux = [aux objectForKey:@"temp_max"];
        [container setCityMaxTemp:strAux];
        
        arrAux = [listObj objectForKey:@"weather"];
        aux = [arrAux objectAtIndex:0];
        
        WeatherType *weather = [[WeatherType alloc] init];
        
        [weather setWeatherDescription:[aux objectForKey:@"description"]];
        [weather setWeatherIcon:[aux objectForKey:@"icon"]];
        [container setCityWeather:weather];
    
        NSLog(@"Container: %@", [container toString]);
        [dataSource addObject:container];
    }
    
    if ([dataSource count] > 0) {
        [self.tableView reloadData];
    }
    [self spinnerActivity:NO];
}

-(void)errorBlock:(NSError *)error{
    NSLog(@"Error: %@", error);
    [self spinnerActivity:NO];
    [self messageBox:@"An error occurred on your connection, please check and try again!"];
}

#pragma mark - Alerts

-(void)messageBox:(NSString *)msg{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"CityWeather" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [dataSource count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    container = [dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [container cityName];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self showAction:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - ModalView

- (void)showAction:(NSIndexPath *)indexPath{
    
    container = [dataSource objectAtIndex:indexPath.row];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 250)];
    
    CGRect cityLabelRect = contentView.bounds;
    cityLabelRect.origin.y = 20;
    cityLabelRect.size.height = 20;
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:cityLabelRect];
    cityLabel.text = [container cityName];
    cityLabel.font = [UIFont boldSystemFontOfSize:17];
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.shadowColor = [UIColor blackColor];
    cityLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:cityLabel];
    
    UIImageView *imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [imgIcon setCenter:CGPointMake(contentView.frame.size.width/2, 60)];
    [imgIcon setImageWithURL:[NSURL URLWithString:[container cityWeather].getIconURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [contentView addSubview:imgIcon];
    
    UILabel *maxTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 80, 80, 20)];
    [maxTitle setText:@"MAX"];
    [maxTitle setBackgroundColor:[UIColor clearColor]];
    [maxTitle setTextColor:[UIColor whiteColor]];
    [maxTitle setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 100, 80, 60)];
    [maxLabel setBackgroundColor:[UIColor clearColor]];
    [maxLabel setTextColor:[UIColor whiteColor]];
    [maxLabel setText:[container getMaxTemp]];
    [maxLabel setTextAlignment:NSTextAlignmentCenter];
    [maxLabel setFont:[UIFont boldSystemFontOfSize:42]];
    
    UILabel *minTitle = [[UILabel alloc] initWithFrame:CGRectMake(160, 80, 80, 20)];
    [minTitle setText:@"MIN"];
    [minTitle setBackgroundColor:[UIColor clearColor]];
    [minTitle setTextColor:[UIColor whiteColor]];
    [minTitle setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *minLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 100, 80, 60)];
    [minLabel setBackgroundColor:[UIColor clearColor]];
    [minLabel setTextColor:[UIColor whiteColor]];
    [minLabel setText:[container getMinTemp]];
    [minLabel setTextAlignment:NSTextAlignmentCenter];
    [minLabel setFont:[UIFont boldSystemFontOfSize:42]];
    
    UILabel *weatherDesc = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 280, 20)];
    [weatherDesc setBackgroundColor:[UIColor clearColor]];
    [weatherDesc setTextColor:[UIColor whiteColor]];
    [weatherDesc setTextAlignment:NSTextAlignmentCenter];
    [weatherDesc setText:[container cityWeather].weatherDescription];
    
    [contentView addSubview:maxLabel];
    [contentView addSubview:maxTitle];
    [contentView addSubview:minLabel];
    [contentView addSubview:minTitle];
    [contentView addSubview:weatherDesc];
    
    [KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeRight;
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}

@end

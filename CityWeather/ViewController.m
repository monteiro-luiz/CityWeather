//
//  ViewController.m
//  CityWeather
//
//  Created by Luiz Monteiro on 20/07/16.
//  Copyright © 2016 LuizMonteiro. All rights reserved.
//

#import "ViewController.h"
#import "Utils.h"


@interface ViewController ()

@end

@implementation ViewController
@synthesize mapView;

#pragma mark - Cycle Life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    if(IS_OS_8_OR_LATER){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [locationManager  requestWhenInUseAuthorization];
            }else{
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    buttonIsShow = NO;
    [self initLocationService];
    [self configureMap];
    [self addGestureOnMap];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions for Button

-(void)searchClick:(id)sender{
    NSLog(@"Search Click");
    
    if (self.cityView == nil) {
        self.cityView = [self.storyboard instantiateViewControllerWithIdentifier:@"cityView"];
    }
    
    self.cityView.coordinates = touchMapCoordinate;
    [self.navigationController pushViewController:self.cityView animated:YES];

}

-(void)showButton{
    
    CGRect frame;
    if (IS_IPHONE_4_OR_LESS) {
        frame = CGRectMake(-100, 587, 60, 60);
    }else if (IS_IPHONE_5){
        frame = CGRectMake(-100, 587, 60, 60);
    }else if (IS_IPHONE_6){
        frame = CGRectMake(-100, 587, 60, 60);
    }else if (IS_IPHONE_6P){
        frame = CGRectMake(-100, 587, 60, 60);
    }
    searchButton = [[UIButton alloc] initWithFrame:frame];
    [searchButton addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setImage:[UIImage imageNamed:@"search-button"] forState:UIControlStateNormal];
    
    [UIView beginAnimations:@"buttonCreate" context:nil];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if (IS_IPHONE_4_OR_LESS) {
        frame = CGRectMake(295, 587, 60, 60);
    }else if (IS_IPHONE_5){
        frame = CGRectMake(295, 587, 60, 60);
    }else if (IS_IPHONE_6){
        frame = CGRectMake(295, 587, 60, 60);
    }else if (IS_IPHONE_6P){
        frame = CGRectMake(295, 587, 60, 60);
    }
    
    [searchButton setFrame:frame];
    [self.view addSubview:searchButton];
    
    [UIView commitAnimations];
}

#pragma mark - MapsFunctions

-(void)addPinOnMap:(CGPoint)point pinTitle:(NSString *)title subTitle:(NSString *)subtitle{
    
    for (id<MKAnnotation> annotation in [self.mapView annotations]) {
        if (![annotation isKindOfClass:[MKUserLocation class]]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
    
    touchMapCoordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    location = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = touchMapCoordinate;
    annotation.title = title;
    annotation.subtitle = subtitle;
    [self.mapView addAnnotation: annotation];
    
    if (!buttonIsShow) {
        buttonIsShow = YES;
        [self showButton];
    }
    
}

-(void)initLocationService{
    
    [locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    [locationManager setDistanceFilter:100];
    [locationManager startUpdatingLocation];
    
}

-(void) configureMap{
    CLLocationCoordinate2D  ctrpoint;
    ctrpoint.latitude = locationManager.location.coordinate.latitude;
    ctrpoint.longitude = locationManager.location.coordinate.longitude;
    
     NSLog(@"Lat: %f - Lon: %f", ctrpoint.latitude, ctrpoint.longitude);
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(ctrpoint, 1000000, 1000000);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
}

-(void)tapOnMap:(UIGestureRecognizer *)gestureRecognizer{

    NSLog(@"Gesture Recognizer!");
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    [self addPinOnMap:touchPoint pinTitle:@"InLoco" subTitle:@"15 Cidades"];

}

#pragma mark - Gestures

-(void)addGestureOnMap{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnMap:)];
    [self.mapView addGestureRecognizer:tap];
}

@end

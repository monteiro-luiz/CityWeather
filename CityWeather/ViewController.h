//
//  ViewController.h
//  CityWeather
//
//  Created by Luiz Monteiro on 20/07/16.
//  Copyright © 2016 LuizMonteiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CityViewController.h"

@interface ViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D touchMapCoordinate;
    CLLocation *location;
    UIButton *searchButton;
    BOOL buttonIsShow;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, strong) CityViewController *cityView;

@end


//
//  CityViewController.h
//  CityWeather
//
//  Created by Luiz Monteiro on 20/07/16.
//  Copyright © 2016 LuizMonteiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityData.h"
#import <MapKit/MapKit.h>
#import "WeatherType.h"

@interface CityViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *dataSource;
    CityData *container;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, readwrite) CLLocationCoordinate2D coordinates;

@end

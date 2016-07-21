//
//  CityData.h
//  CityWeather
//
//  Created by Luiz Monteiro on 20/07/16.
//  Copyright © 2016 LuizMonteiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherType.h"

@interface CityData : NSObject{
    NSString *cityName;
    NSString *cityMaxTemp;
    NSString *cityMinTemp;
    WeatherType *cityWeather;
}

@property(nonatomic, strong) NSString *cityName;
@property(nonatomic, strong) NSString *cityMaxTemp;
@property(nonatomic, strong) NSString *cityMinTemp;
@property(nonatomic, strong) WeatherType *cityWeather;

-(NSString *)toString;
-(NSString *)getMaxTemp;
-(NSString *)getMinTemp;

@end

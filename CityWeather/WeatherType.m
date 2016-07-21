//
//  WeatherType.m
//  CityWeather
//
//  Created by Luiz Monteiro on 21/07/16.
//  Copyright © 2016 LuizMonteiro. All rights reserved.
//

#import "WeatherType.h"
#import "Utils.h"

@implementation WeatherType
@synthesize weatherIcon, weatherDescription;

-(NSString *)getIconURL{
    return [[ICON_URL stringByAppendingString:weatherIcon] stringByAppendingString:@".png"];
}
@end

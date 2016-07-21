//
//  CityData.m
//  CityWeather
//
//  Created by Luiz Monteiro on 20/07/16.
//  Copyright © 2016 LuizMonteiro. All rights reserved.
//

#import "CityData.h"

@implementation CityData

@synthesize cityName, cityMaxTemp, cityMinTemp, cityWeather;


-(NSString *)toString{
    return [NSString stringWithFormat:@"City Info # Name: %@ # Max Temp: %@ # Min Temp: %@", cityName, cityMaxTemp, cityMinTemp];
}

-(NSString *)getMaxTemp{
    
    return [NSString stringWithFormat:@"%@°", [self splitByDot:cityMaxTemp]];
}

-(NSString *)getMinTemp{
    return [NSString stringWithFormat:@"%@°", [self splitByDot:cityMinTemp]];
}

-(NSString *)splitByDot:(NSString *)temp{
    NSString *aux;
    temp = [NSString stringWithFormat:@"%@", temp];
    
    if ([temp rangeOfString:@"."].length != 0) {
        NSArray *arr = [temp componentsSeparatedByString:@"."];
        aux = [arr objectAtIndex:0];
        return aux;
    }else{
        return temp;
    }
    
}
@end

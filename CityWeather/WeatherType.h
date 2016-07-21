//
//  WeatherType.h
//  CityWeather
//
//  Created by Luiz Monteiro on 21/07/16.
//  Copyright © 2016 LuizMonteiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherType : NSObject{
    NSString *weatherDescription;
    NSString *weatherIcon;
}

@property(nonatomic, strong) NSString *weatherDescription;
@property(nonatomic, strong) NSString *weatherIcon;

-(NSString *)getIconURL;
@end

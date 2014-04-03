//
//  Trade.h
//  BF
//
//  Created by Romain DONON on 28/02/2014.
//  Copyright (c) 2014 Romain DONON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contacts;

@interface Trade : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSNumber * way;
@property (nonatomic, retain) Contacts *contact;

@end

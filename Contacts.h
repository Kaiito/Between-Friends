//
//  Contacts.h
//  BF
//
//  Created by Romain DONON on 23/02/2014.
//  Copyright (c) 2014 Romain DONON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Trade;

@interface Contacts : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * phoneNumber;
@property (nonatomic, retain) NSNumber * recordid;
@property (nonatomic, retain) NSSet *trades;
@end

@interface Contacts (CoreDataGeneratedAccessors)

- (void)addTradesObject:(Trade *)value;
- (void)removeTradesObject:(Trade *)value;
- (void)addTrades:(NSSet *)values;
- (void)removeTrades:(NSSet *)values;

@end

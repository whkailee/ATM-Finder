//
//  BaseModel.m
//  ATMFinder
//
//  Created by Steven Li on 22/07/16.
//  Copyright © 2016 Xinc. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

static NSString * const kNSDecimalNumberPropertyPrefix = @"T@\"NSDecimalNumber\"";

@implementation BaseModel

@synthesize jsonObject = _jsonObject;


static NSMutableDictionary* _tramsformPropertiesToNSDecimalNumber = nil;
static NSArray * _zeroArray;


+ (void)load
{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        _tramsformPropertiesToNSDecimalNumber = [NSMutableDictionary new];
        _zeroArray = @[];
    });
}


- (instancetype)init
{
    // Call designated initializer
    if (self = [self initWithJSON:nil]) { }
    return self;
}

- (instancetype)initWithJSON:(id)json
{
    if (self = [super init])
    {
        self.jsonObject = json;
    }
    
    return self;
}

+ (instancetype)modelFromJSONObject:(id)json
{
    return [[[self class] alloc] initWithJSON:json];
}

+ (instancetype)instanceFromDictionary:(NSDictionary *)aDictionary
{
    id instance = [[[self class] alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary
{
    if (![aDictionary isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    
    [self setValuesForKeysWithDictionary:aDictionary];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // We don't worry about properties that cannot be mapped from JSON to our models - We are not using it.
    // Calling [super setValue:value forUndefinedKey:key]; to an unmapped key will raise an exception, which we don't want
    NSLog(@"%@[%@] = %@ (Unmapped key from JSON to model object)", [self class], key, value);
}


- (void)setValue:(id)value forKey:(NSString *)key
{
    
    if([value isKindOfClass:[NSNumber class]] && ![value isMemberOfClass:[NSDecimalNumber class]] && [self shouldBeNSDecimalNumberForKey:key])
    {
        value = [NSDecimalNumber decimalNumberWithDecimal:[((NSNumber*)value) decimalValue]];
    }
    [super setValue:value forKey:key];
}

- (BOOL)shouldBeNSDecimalNumberForKey:(NSString *)key
{
    
    for (NSString* propertyName in [self arrayOfPropertiesToTransformToNSDecimalNumber]) {
        if([propertyName compare:key options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            return YES;
        }
    }
    return NO;
    
}

- (NSArray*)arrayOfPropertiesToTransformToNSDecimalNumber
{
    
    NSString* className = NSStringFromClass([self class]);
    NSArray* tempArray = _tramsformPropertiesToNSDecimalNumber[className];
    
    if(!tempArray)
    {
        @synchronized(_tramsformPropertiesToNSDecimalNumber)
        {
            tempArray = _tramsformPropertiesToNSDecimalNumber[className];
            if(!tempArray)
            {
                NSMutableArray *arrayOfNSDecimalNumberProperties = [NSMutableArray new];
                
                unsigned count;
                objc_property_t *properties = class_copyPropertyList([self class], &count);
                
                unsigned i;
                
                for (i = 0; i < count; i++)
                {
                    objc_property_t property = properties[i];
                    
                    NSString *typeOfProperty = [NSString stringWithUTF8String:property_getAttributes(property)];
                    
                    if([typeOfProperty hasPrefix:kNSDecimalNumberPropertyPrefix])
                    {
                        NSString* name = [NSString stringWithUTF8String:property_getName(property)];
                        [arrayOfNSDecimalNumberProperties addObject:name];
                    }
                }
                free(properties);
                
                if(arrayOfNSDecimalNumberProperties.count > 0)
                {
                    tempArray = [arrayOfNSDecimalNumberProperties copy];
                }
                else
                {
                    tempArray = _zeroArray;
                }
            }
            _tramsformPropertiesToNSDecimalNumber[className] = tempArray;
        }
    }
    return tempArray;
}





+ (BOOL)transformValueArray:(id)value toArrayOf:(Class)arrayClass outArray:(NSArray**)outArray
{
    if (![value isKindOfClass:[NSArray class]])
    {
        *outArray = [NSArray new];
        return false;
    }
    
    NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
    for (id valueMember in value) {
        id populatedMember = [arrayClass instanceFromDictionary:valueMember];
        [myMembers addObject:populatedMember];
    }
    
    *outArray = myMembers;
    return true;
}

@end


@implementation NSObject (JsonToPrimitiveExensions)

- (int)intForKeyExtension:(NSString *)key
{
    return [(NSNumber *)[self valueForKey:key] intValue];
}

- (bool)boolForKeyExtension:(NSString *)key
{
    return [(NSNumber *)[self valueForKey:key] boolValue];
}

- (double)doubleForKeyExtension:(NSString *)key
{
    return [(NSDecimalNumber *)[self valueForKey:key] doubleValue];
}

@end

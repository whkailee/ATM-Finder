//
//  BaseModel.h
//  ATMFinder
//
//  Created by Steven Li on 22/07/16.
//  Copyright © 2016 Xinc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @interface ASBBaseModel
 @defgroup Models
 @{
 @brief Web Service Interface Models
 
 Entity models passed between the app and web services
 @{
 */
/**
 @brief Base model
 
 Base class from which other models inherit
 
 */
@interface BaseModel : NSObject

/**
	The JSON representation of the model
 */
@property (nonatomic, strong) id jsonObject;

/**
	@brief Initializer
	@param json A JSON object to initialise the model from
	@returns self
 */
- (instancetype)initWithJSON:(id)json;

/**
 @brief Initializer
 @returns self
 */
- (instancetype)init;

/**
	Create a model
	@param json A JSON object to initialise the model from
	@returns self
 */
+ (instancetype)modelFromJSONObject:(id)json;

/**
 Create a model
 @param aDictionary A dictionary to initialise the model from
 @returns self
 @note Must be overridden in any sub-classes
 */
+ (instancetype)instanceFromDictionary:(NSDictionary *)aDictionary;


+ (BOOL)transformValueArray:(id)value toArrayOf:(Class)arrayClass outArray:(NSArray**)outArray;


/**
 Set the model attributes from a dictionary
 @param aDictionary A dictionary to set the model from
 @returns self
 @note Must be overridden in any sub-classes
 */
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end

/** @} */

/** @} */

// NSObject extensions for easy primitive conversation fron JSON when doing initWithJSON
@interface NSObject (JsonToPrimitiveExensions)

- (int)intForKeyExtension:(NSString *)key;
- (bool)boolForKeyExtension:(NSString *)key;
- (double)doubleForKeyExtension:(NSString *)key;

@end

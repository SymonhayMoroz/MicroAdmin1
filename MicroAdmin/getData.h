//
//  getData.h
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface getData : NSObject

//+ (NSArray *)getBusinesses;
//+ (NSArray *)getBusinesses:(float)offsetFromCurrentLocation;
//+ (NSArray *)getBusinessDetail:(NSArray *)ids;
//+ (NSURLRequest *)searchRequest:(CLLocationCoordinate2D)coord withOffset:(long)offset;
//+ (NSURL *)URLforRatingAsset:(NSString *)rating;
//+ (NSString *)CategoryString:(NSArray *)categoryArray;
//+ (NSString *)styledPhoneNumber:(NSString *)phoneNumber;

//+ (NSArray *)getRequest;

+ (NSURLRequest *)searchRequest;
+ (NSURLRequest *)searchRequestContact:(NSString*)contactID;

+ (NSURLRequest *)DeleteRequestContact:(NSString*)postString;

+ (NSURLRequest *)UpdateRequestContact:(NSString*)postString;
// KKK request_for_getCategory
//+ (NSURLRequest *)searchRequest_for_getCategory:(NSString*)zipCdoe withOffset:(long)offset;
//+ (NSURLRequest *)searchRequest_for_getCategory_location:(CLLocationCoordinate2D)coord withOffset:(long)offset;

extern NSMutableDictionary *contactsData;
extern NSMutableArray *orderedKeys;
@end

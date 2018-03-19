//
//  MDYAFHelp.h
//  MDYNews
//
//  Created by Medalands on 15/2/26.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

@interface MDYAFHelp : NSObject

//------------------请求--------------------
/**
 * 请求成功 调用block
 */
@property (nonatomic,strong)void (^callBackSuccess) ();

/**
 * 请求失败 调用Block
 */
@property (nonatomic,strong)void (^callBackFailure) ();


@property (nonatomic,weak)AFHTTPRequestOperation *operation;


// 可以在（setDefaultParamToDic:）这个类方法里 设置 默认给每个接口添加 固定的参数 

/**
 *  get 请求
 
   第一个参数 hostString 是 域名
   第二个参数 bindPath 是 域名后面除了 参数的 接口
   第三个参数 dic 是get 请求的 参数

 */
+(MDYAFHelp*)AFGetHost:(NSString*)hostString  bindPath:(NSString *)bindPath param:(NSMutableDictionary*)dic success:( void (^) ( AFHTTPRequestOperation *operation,NSDictionary* responseDic) )success failure:(void (^)( AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 * Post 请求
 
    第一个参数 hostString 是 域名
    第二个参数 bindPath 是 域名后面除了 参数的 接口
   第三个参数 postParam 是Post参数
   第三个参数 getParam  是Post请求的get参数 一般为空 nil
 */
+(MDYAFHelp *)AFPostHost:(NSString *)hostString bindPath:(NSString *)bindPath postParam:(NSMutableDictionary *)postParam getParam:(NSMutableDictionary *)getParam success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *responseDic))success failure:(void (^)(AFHTTPRequestOperation * operation, NSError *error))failure;
@end

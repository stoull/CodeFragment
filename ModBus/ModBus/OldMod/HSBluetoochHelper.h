//
//  HSBluetoochHelper.h
//  ShinePhone
//
//  Created by growatt007 on 2018/7/19.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSBluetoochHelper : NSObject

/**
 发送指令
 
 @param protocol 协议类型
 @param cmd 消息类型
 @param dataLength 有效数据的长度
 @param payload 有效数据
 */
+ (NSData *)sendDataProtocol:(NSString *)protocol Cmd:(NSString *)cmd DataLenght:(int)dataLength Payload:(Byte[])payload Mask:(Byte[])mask Useless:(Byte[])useless;

/**
 Payload数据做掩码加密或解密
 
 @param Payload pyyload
 @param length 长度
 @param mask 掩码
 @return 加密后的数据
 */
+ (NSData *)MaskEncryption:(Byte[])Payload length:(int)length Mask:(Byte[])mask;

/**
 和校验，取低8位 -- 取前面数据总和，再与0xff，取低8位
 
 @param bytes byte数组
 @param length 数组长度
 @return 返回校验值
 */
+ (long int)checkSumWithData:(Byte[])bytes length:(int)length;


// 获取当前时间字符串
+ (NSData *)getCurrentTime;


//将NSData转换成十六进制的字符串
+ (NSString *)convertDataToHexStr:(NSData *)data;


//将传入的NSString类型转换成ASCII码并返回
+ (NSData*)dataWithString:(NSString *)string;


// 16进制转10进制
+ (NSNumber *) numberHexString:(NSString *)aHexString;


#pragma mark --  10进制转16进制,返回为2字节,不带"0x"开头
+ (NSString *)ToHex:(int)tmpid;

#pragma mark --  把数值比较大的10进制转16进制 ,不带"0x"开头， 例如 1000 转成 03e8
+ (NSString *)ToHex2:(int)tmpid;
//将传入的NSString类型转换成ASCII码并返回 , 不足位数补00
+ (NSData*)dataWithString:(NSString *)string length:(NSInteger)length;

// 获取当前时间字符串  0 - 返回15位   1 - 返回14位
+ (NSData *)getCurrentTimeType:(NSString *)type;

/**
    WiFi指令
 */
+ (NSData *)wifiSendDataProtocol:(NSString *)protocol Cmd:(NSString *)cmd DataLenght:(int)dataLength Payload:(Byte[])payload Mask:(Byte[])mask Useless:(Byte[])useless;

@end

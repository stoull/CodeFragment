//
//  HSBluetoochHelper.m
//  ShinePhone
//
//  Created by growatt007 on 2018/7/19.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "HSBluetoochHelper.h"

@implementation HSBluetoochHelper

/**
 发送指令
 
 @discussion
 帧头：1字节， 0xA8
 帧头：1字节， 0x8A
 协议类型：1字节， 0x01表示交流桩，0x02表示直流桩，0x03表示交直流桩
 加密类型：1字节，0x00表示不加密，0x01表示掩码加密，其他加密预留
 消息类型：1字节，对应业务流程命令类型
 数据长度：1字节，指示有效数据长度
 有效数据：低字节在前，高字节在后。最长(240字节)
 数据校验：1字节，和校验，取低字节
 结束符：1字节， 0x88
 
 @param protocol 协议类型
 @param cmd 消息类型
 @param dataLength 有效数据的长度
 @param payload 有效数据
 */
+ (NSData *)sendDataProtocol:(NSString *)protocol Cmd:(NSString *)cmd DataLenght:(int)dataLength Payload:(Byte[])payload Mask:(Byte[])mask Useless:(Byte[])useless
{
    //先以16为参数告诉strtoul字符串参数表示16进制数字
    Byte bytes[] = {};
    bytes[0] = 0xa8; // 帧头
    bytes[1] = 0x8a; // 帧头
    bytes[2] = strtoul([protocol UTF8String], 0, 0); // 协议类型
    bytes[3] = 0x01; // 加密类型
    bytes[4] = strtoul([cmd UTF8String], 0, 0); // 消息类型
    bytes[5] = strtoul([[self ToHex:dataLength] UTF8String], 0, 16); // 有效数据的长度,转16进制
    NSLog(@"加密前的有效数据: %@",[NSData dataWithBytes:payload length:dataLength]);
    // 有效数据进行掩码加密
    NSData *PayloadData = [self MaskEncryption:payload length:dataLength Mask:mask];
    NSLog(@"加密后的有效数据: %@", PayloadData);
    
    // byte转Data数据再进行拼接
    NSMutableData *bytesData = [[NSMutableData alloc]initWithBytes:bytes length:6];
    [bytesData appendData:PayloadData];
    
    // 转回byte类型
    Byte *bytes2 = (Byte *)[bytesData bytes];
    bytes2[bytesData.length] = [self checkSumWithData:bytes2 length:(int)bytesData.length]; // 数据校验
    bytes2[bytesData.length + 1] = 0x88; // 结束符
    
    NSData *sendByteData = [NSData dataWithBytes:bytes2 length:bytesData.length + 2];
    NSLog(@"最后发送的完整 sendByteData: %@",sendByteData);
    return sendByteData;
}


/**
 Payload数据做掩码加密
 
 @param Payload pyyload
 @param length 长度
 @param mask 掩码
 @return 加密后的数据
 */
+ (NSData *)MaskEncryption:(Byte[])Payload length:(int)length Mask:(Byte[])mask
{
    for(int j=0; j < length ;j++)
    {
        Payload[j] = Payload[j] ^ mask[j%4];
    }
    
    NSData *PayloadData = [NSData dataWithBytes:Payload length:length];
    
    return PayloadData;
}


/**
 和校验，取低8位 -- 取前面数据总和，再与0xff，取低8位
 
 @param bytes byte数组
 @param length 数组长度
 @return 返回校验值
 */
+ (long int)checkSumWithData:(Byte[])bytes length:(int)length
{
    int sum = 0;
    for (int i = 0; i < length; i++) sum += (int)bytes[i];
    return sum & 0xff;
}



#pragma mark -- 将NSData转换成十六进制的字符串
+ (NSString *)convertDataToHexStr:(NSData *)data
{
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

 #pragma mark -- 获取当前时间字符串
+ (NSData *)getCurrentTime
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int year =(int) [dateComponent year];
    int month = (int) [dateComponent month];
    int day = (int) [dateComponent day];
    int hour = (int) [dateComponent hour];
    int minute = (int) [dateComponent minute];
    int second = (int) [dateComponent second];
    
    //字符串的转化并且拼接
    NSString *yearstr=[self stringWithInteget:(long)year];
    NSString *monthstr=[self stringWithInteget:(long)month];
    NSString *daystr=[self stringWithInteget:(long)day];
    NSString *hourstr=[self stringWithInteget:(long)hour];
    NSString *minutestr=[self stringWithInteget:(long)minute];
    NSString *secondstr=[self stringWithInteget:(long)second];
    
    NSString *TimeString = [NSString stringWithFormat:@"%@%@%@_%@%@%@",yearstr,monthstr,daystr,hourstr,minutestr,secondstr];
    NSData *timeData = [self dataWithString:TimeString];
    NSLog(@"TimeString: %@, timeData: %@", TimeString, timeData);
    
    return timeData;
}
// 不足两位前面补零
+ (NSString *)stringWithInteget:(NSInteger)num
{
    NSString *str = [NSString stringWithFormat:@"%ld",num];
    while (str.length < 2) str = [NSString stringWithFormat:@"0%@",str];
    return str;
}


#pragma mark -- 将传入的NSString类型转换成ASCII码并返回
+ (NSData*)dataWithString:(NSString *)string
{
    unsigned char *bytes = (unsigned char *)[string UTF8String];
    NSInteger len = string.length;
    return [NSData dataWithBytes:bytes length:len];
}


#pragma mark --  10进制转16进制,返回为2字节,不带"0x"开头
+ (NSString *)ToHex:(int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        
        ttmpig=tmpid%16;

        tmpid=tmpid/16;
        
        switch (ttmpig)
        {
            case 10:   nLetterValue =@"A";break;
            case 11:   nLetterValue =@"B";break;
            case 12:   nLetterValue =@"C";break;
            case 13:   nLetterValue =@"D";break;
            case 14:   nLetterValue =@"E";break;
            case 15:   nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    str = str.length == 1 ? [NSString stringWithFormat:@"0%@",str] : str ;
    return str;
}

#pragma mark --  把数值比较大的10进制转16进制 ,不带"0x"开头， 例如 1000 转成 03e8
+ (NSString *)ToHex2:(int)tmpid
{
    NSString *str =@"";
    int tmpid2;
    do {
        tmpid2 = tmpid%256;
        tmpid = tmpid/256;
        str = [NSString stringWithFormat:@"%@%@", [self ToHex:tmpid2],str];
    } while (tmpid != 0);
    
    return str;
}


#pragma mark -- 高低位互换
- (NSString *)transform:(NSString *)string
{
    NSLog(@"高地位互换-%@",string);
    
    NSString *str = [NSString stringWithFormat:@"%@",string];
    
    for (int i = (int)string.length ; i< 4; i++)
    {
        str =  [NSString stringWithFormat:@"0%@",str];
    }
    return [[str substringWithRange:NSMakeRange(2, 2)] stringByAppendingString:[str substringWithRange:NSMakeRange(0, 2)]];
}

// 16进制转10进制
+ (NSNumber *) numberHexString:(NSString *)aHexString
{
    // 为空,直接返回.
    if (nil == aHexString)
    {
        return nil;
    }
    NSScanner * scanner = [NSScanner scannerWithString:aHexString];
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];
    //将整数转换为NSNumber,存储到数组中,并返回.
    NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];
    
    return hexNumber;
}

// 按规定位数返回，不足补00
+ (NSData*)dataWithString:(NSString *)string length:(NSInteger)length
{
    unsigned char *bytes = (unsigned char *)[string UTF8String];
    NSInteger len = string.length;
    NSMutableData *strData = [[NSMutableData alloc]initWithBytes:bytes length:len];
    if(strData.length > length){ // 判断是否超出位数
        return [NSData data];
    }
    
    // 不足补零
    NSMutableData *mutalData = [[NSMutableData alloc]init];
    while (mutalData.length < length-strData.length) {
        [mutalData appendData:[NSData dataWithBytes:[@"" UTF8String] length:1]];
    }
    [strData appendData:mutalData];
    
    return strData;
}

 #pragma mark -- 获取当前时间字符串
+ (NSData *)getCurrentTimeType:(NSString *)type
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSUInteger unitFlags = NSCalendarUnitDay | NSCalendarUnitDay | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int year =(int) [dateComponent year];
    int month = (int) [dateComponent month];
    int day = (int) [dateComponent day];
    int hour = (int) [dateComponent hour];
    int minute = (int) [dateComponent minute];
    int second = (int) [dateComponent second];
    
    //字符串的转化并且拼接
    NSString *yearstr=[self stringWithInteget:(long)year];
    NSString *monthstr=[self stringWithInteget:(long)month];
    NSString *daystr=[self stringWithInteget:(long)day];
    NSString *hourstr=[self stringWithInteget:(long)hour];
    NSString *minutestr=[self stringWithInteget:(long)minute];
    NSString *secondstr=[self stringWithInteget:(long)second];
    
    NSString *TimeString = [NSString stringWithFormat:@"%@%@%@_%@%@%@",yearstr,monthstr,daystr,hourstr,minutestr,secondstr];
    
    if([type isEqualToString:@"1"]){
        TimeString = [NSString stringWithFormat:@"%@%@%@%@%@%@",yearstr,monthstr,daystr,hourstr,minutestr,secondstr];
    }
    
    NSData *timeData = [self dataWithString:TimeString];
    NSLog(@"TimeString: %@, timeData: %@", TimeString, timeData);
    
    return timeData;
}

/**
 WiFi 发送指令
 
 @discussion
 帧头：1字节， 0x5a
 帧头：1字节， 0x5a
 协议类型：1字节， 0x01表示交流桩，0x02表示直流桩，0x03表示交直流桩
 加密类型：1字节，0x00表示不加密，0x01表示掩码加密，其他加密预留
 消息类型：1字节，对应业务流程命令类型
 数据长度：1字节，指示有效数据长度
 有效数据：低字节在前，高字节在后。最长(240字节)
 数据校验：1字节，和校验，取低字节
 结束符：1字节， 0x88
 
 @param protocol 协议类型
 @param cmd 消息类型
 @param dataLength 有效数据的长度
 @param payload 有效数据
 */
+ (NSData *)wifiSendDataProtocol:(NSString *)protocol Cmd:(NSString *)cmd DataLenght:(int)dataLength Payload:(Byte[])payload Mask:(Byte[])mask Useless:(Byte[])useless
{
    //先以16为参数告诉strtoul字符串参数表示16进制数字
    Byte bytes[] = {};
    bytes[0] = 0x5a; // 帧头
    bytes[1] = 0x5a; // 帧头
    bytes[2] = strtoul([protocol UTF8String], 0, 0); // 协议类型
    bytes[3] = 0x01; // 加密类型
    bytes[4] = strtoul([cmd UTF8String], 0, 0); // 消息类型
    bytes[5] = strtoul([[self ToHex:dataLength] UTF8String], 0, 16); // 有效数据的长度,转16进制
    NSLog(@"加密前的有效数据: %@",[NSData dataWithBytes:payload length:dataLength]);
    // 有效数据进行掩码加密
    NSData *PayloadData = [self MaskEncryption:payload length:dataLength Mask:mask];
    NSLog(@"加密后的有效数据: %@", PayloadData);
    
    // byte转Data数据再进行拼接
    NSMutableData *bytesData = [[NSMutableData alloc]initWithBytes:bytes length:6];
    [bytesData appendData:PayloadData];
    
    // 转回byte类型
    Byte *bytes2 = (Byte *)[bytesData bytes];
    bytes2[bytesData.length] = [self checkSumWithData:bytes2 length:(int)bytesData.length]; // 数据校验
    bytes2[bytesData.length + 1] = 0x88; // 结束符
    
    NSData *sendByteData = [NSData dataWithBytes:bytes2 length:bytesData.length + 2];
    NSLog(@"最后发送的完整 sendByteData: %@",sendByteData);
    return sendByteData;
}
@end

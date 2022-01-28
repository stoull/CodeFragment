//
//  HSBluetoochManager.h
//  ShinePhone
//
//  Created by growatt007 on 2018/7/17.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface HSBluetoochManager : NSObject

+ (HSBluetoochManager *)instance;

@property (nonatomic, strong) NSMutableDictionary *ChargDictionary;

@property (nonatomic, copy) void (^GetBluePeripheralBlock)(id obj);  // 搜索蓝牙结果

@property (nonatomic, copy) void (^ConnectBluePeripheralBlock)(id obj);  // 连接结果

@property (nonatomic, strong) NSMutableArray *peripheralArray;// 存储的设备

@property (nonatomic, strong) CBPeripheral *cbperipheral;// 扫描到的设备

@property (nonatomic, assign) BOOL isConnectSuccess;

// 扫描设备
- (void)scanForPeripherals;

// 连接设备
- (void)connectToPeripheral:(NSInteger)index;

// 断开连接
- (void)disconnectToPeripheral;

- (void)heartbeat;

/**
 设置定时预约
 
 @param isAppointment 是否预约  0x01表示预约，0x00取消预约
 @param time 预约时间 30min，等待预约时间后启动启动充电。最长预约8小时
 */
- (void)makeAppointment:(BOOL)isAppointment Time:(int)time;

/**
 启动或关闭

 @param isOpen 是否启动
 */
- (void)openOrStop:(BOOL)isOpen;



/**
 参数设置

 @param Charg_ID 充电桩ID
 @param currentVaule 输出电流大小
 @param token_ID 秘钥序列
 @param mode 充电模式
 @param rate 充电费率
 @param language 语言设置
 */
- (void)setChargingpileID:(NSString *)Charg_ID currentVaule:(int)currentVaule token_ID:(NSString *)token_ID mode:(int)mode rate:(int)rate language:(int)language;

/**
 参数获取
 */
- (void)gettingParameter;



@end

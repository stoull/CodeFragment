//
//  HSBluetoochManager.m
//  ShinePhone
//
//  Created by growatt007 on 2018/7/17.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "HSBluetoochManager.h"
#import "HSBluetoochHelper.h"

@interface HSBluetoochManager ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;

@property (nonatomic, assign) CBManagerState peripheralState;// 外设状态

@property (nonatomic, strong) CBCharacteristic *writeChatacteristic; // 写特征

@property (nonatomic, strong) CBCharacteristic *readCharacteristic; // 读特征

@property (nonatomic, strong) NSMutableData *NotificationData;

@end

// 蓝牙4.0设备名 5314EEEC-427F-4BB8-9842-46A6977B608E
static NSString * const kBlePeripheralName = @"Growatt_0002";
// 通知服务
static NSString * const kNotifyServerUUID = @"49535343-FE7D-4AE5-8FA9-9FAFD205E455";
// 写服务
static NSString * const kWriteServerUUID = @"49535343-FE7D-4AE5-8FA9-9FAFD205E455";
// 通知特征值
static NSString * const kNotifyCharacteristicUUID = @"49535343-1E4D-4BD9-BA61-23C647249616";
// 写特征值
static NSString * const kWriteCharacteristicUUID =  @"49535343-8841-43F4-A8D4-ECBE34729BB3";

Byte loginMask[4] = {0x5a, 0xa5, 0x5a, 0xa5}; // 登录掩码

Byte randomMask[4] = {}; // 随机掩码

@implementation HSBluetoochManager


+ (HSBluetoochManager *)instance {
    static dispatch_once_t onceToken;
    static HSBluetoochManager *bluetoothManager;
    dispatch_once(&onceToken, ^{
        bluetoothManager = [[HSBluetoochManager alloc]init];
    });
    return bluetoothManager;
}

- (instancetype)init{
    if (self = [super init]) {
        self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
        randomMask[0] = strtoul([[HSBluetoochHelper ToHex:arc4random() % 256] UTF8String], 0, 16);
        randomMask[1] = strtoul([[HSBluetoochHelper ToHex:arc4random() % 256] UTF8String], 0, 16);
        randomMask[2] = strtoul([[HSBluetoochHelper ToHex:arc4random() % 256] UTF8String], 0, 16);
        randomMask[3] = strtoul([[HSBluetoochHelper ToHex:arc4random() % 256] UTF8String], 0, 16);
    }
    return self;
}

- (NSMutableArray *)peripheralArray{
    if (!_peripheralArray) {
        _peripheralArray = [NSMutableArray array];
    }
    return _peripheralArray;
}

- (NSMutableData *)NotificationData{
    if (!_NotificationData) {
        _NotificationData = [[NSMutableData alloc]init];
    }
    return _NotificationData;
}

- (NSMutableDictionary *)ChargDictionary{
    if (!_ChargDictionary) {
        _ChargDictionary = [[NSMutableDictionary alloc]init];
    }
    return _ChargDictionary;
}

// 扫描设备
- (void)scanForPeripherals{
    [self.centralManager stopScan];
    NSLog(@"扫描设备");
    if (self.peripheralState == CBManagerStatePoweredOn){
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
}

// 连接设备
- (void)connectToPeripheral:(NSInteger)index {
    
    self.cbperipheral = self.peripheralArray[index];
    
    if (self.cbperipheral != nil) {
        NSLog(@"连接设备");
        [self disconnectToPeripheral]; // 断开
        [self.centralManager connectPeripheral:self.cbperipheral options:nil];// 连接
    }else{
        NSLog(@"无设备可连接");
    }
}

// 断开连接
- (void)disconnectToPeripheral{
    if (self.cbperipheral != nil) {
        NSLog(@"断开连接");
        [self.centralManager cancelPeripheralConnection:self.cbperipheral];
    }
}

// 手机蓝牙状态更新时调用
- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
    switch (central.state) {
        case CBManagerStateUnknown:{
            NSLog(@"系统蓝牙当前状态不明确");
            self.peripheralState = central.state;
        }
            break;
        case CBManagerStateResetting:
        {
            NSLog(@"重置状态");
            self.peripheralState = central.state;
        }
            break;
        case CBManagerStateUnsupported:
        {
            NSLog(@"系统蓝牙设备不支持");
            self.peripheralState = central.state;
        }
            break;
        case CBManagerStateUnauthorized:
        {
            NSLog(@"系统蓝未被授权");
            self.peripheralState = central.state;
        }
            break;
        case CBManagerStatePoweredOff:
        {
            NSLog(@"系统蓝牙关闭了，请先打开蓝牙");
            self.peripheralState = central.state;
        }
            break;
        case CBManagerStatePoweredOn:
        {
            NSLog(@"开启状态－可用状态");
            self.peripheralState = central.state;
            
            [self.centralManager scanForPeripheralsWithServices:nil options:nil];
        }
            break;
        default:
            break;
    }
}


/**
 扫描到设备
 
 @param central 中心管理者
 @param peripheral 扫描到的设备
 @param advertisementData 广告信息
 @param RSSI 信号强度
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    if (![self.peripheralArray containsObject:peripheral]){
        [self.peripheralArray addObject:peripheral];
        NSLog(@"搜索到的设备: %@",peripheral);
//        if ([peripheral.name isEqualToString:kBlePeripheralName])
//        {
//            self.cbperipheral = peripheral;
//            [self.centralManager connectPeripheral:peripheral options:nil];
//        }
    }
    if(self.GetBluePeripheralBlock){
        self.GetBluePeripheralBlock(peripheral);
    }
}

/**
 连接失败
 
 @param central 中心管理者
 @param peripheral 连接失败的设备
 @param error 错误信息
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
//    if ([peripheral.name isEqualToString:kBlePeripheralName])
//    {
//        [self.centralManager connectPeripheral:peripheral options:nil];
//    }
    
    if ([peripheral isEqual:self.cbperipheral]) {
        [self.centralManager connectPeripheral:peripheral options:nil]; // 重连
    }
    self.isConnectSuccess = NO; // 连接失败
    if(self.ConnectBluePeripheralBlock){
        self.ConnectBluePeripheralBlock(@"NO");
    }
}

/**
 连接成功
 
 @param central 中心管理者
 @param peripheral 连接成功的设备
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //停止中心管理设备的扫描动作，要不然在你和已经连接好的外设进行数据沟通时，如果又有一个外设进行广播且符合你的连接条件，那么你的iOS设备也会去连接这个设备（因为iOS BLE4.0是支持一对多连接的），导致数据的混乱。
    [self.centralManager stopScan];
    NSLog(@"连接设备:%@成功",peripheral.name);
    self.cbperipheral = peripheral;
    // 设置设备的代理
    peripheral.delegate = self;
    // services:传入nil代表扫描所有服务
    [peripheral discoverServices:nil];
    
    self.isConnectSuccess = YES; // 连接成功
    if(self.ConnectBluePeripheralBlock){
        self.ConnectBluePeripheralBlock(@"YES");
    }
}

// 设备掉线
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"掉线");
    self.isConnectSuccess = NO; // 连接失败
    if(self.ConnectBluePeripheralBlock){
        self.ConnectBluePeripheralBlock(@"NO");
    }
}

/**
 扫描到服务
 
 @param peripheral 服务对应的设备
 @param error 扫描错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    // 遍历所有的服务
    for (CBService *service in peripheral.services)
    {
        NSLog(@"服务:%@",service.UUID.UUIDString);
        // 获取对应的服务
        if ([service.UUID.UUIDString isEqualToString:kWriteServerUUID] || [service.UUID.UUIDString isEqualToString:kNotifyServerUUID])
        {
            // 根据服务去扫描特征
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

/**
 扫描到对应的特征
 
 @param peripheral 设备
 @param service 特征对应的服务
 @param error 错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    // 遍历所有的特征
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        NSLog(@"特征值:%@",characteristic.UUID.UUIDString);
        if ([characteristic.UUID.UUIDString isEqualToString:kWriteCharacteristicUUID])
        {
            self.writeChatacteristic = characteristic;
        }
        if ([characteristic.UUID.UUIDString isEqualToString:kNotifyCharacteristicUUID])
        {
            self.readCharacteristic = characteristic;
            // 订阅特征
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

//向peripheral中写入数据后的回调函数
- (void)peripheral:(CBPeripheral*)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"write value success(写入成功)");
}

/**
 根据特征读到数据
 
 @param peripheral 读取到数据对应的设备
 @param characteristic 特征
 @param error 错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error{
    
    if ([characteristic.UUID.UUIDString isEqualToString:kNotifyCharacteristicUUID])
    {
        NSData *data = characteristic.value;
        NSLog(@"订阅特征读到的数据: %@",data);
        if (!data) return;
        NSData *EndData = [data subdataWithRange:NSMakeRange(data.length - 1, 1)];
        int End = ((Byte *)[EndData bytes])[0];
        [self.NotificationData appendData:data];// 把分段数据合并
        if (End == 0x88) {// 判断结束标志
            NSLog(@"NotificationData: %@", self.NotificationData);
            [self analysis:self.NotificationData];
            self.NotificationData = nil;
        }
    }
}

#pragma mark -- 登录
- (void)loginToID:(NSData *)id_data{
    NSMutableData *bytesData = [[NSMutableData alloc]initWithBytes:randomMask length:4];
    Byte *bytes = (Byte *)[bytesData bytes];
    bytes[4] = 0x0a;// 10 秒
    NSMutableData *bytesData2 = [[NSMutableData alloc]initWithBytes:bytes length:5];
    [bytesData2 appendData:id_data];
    Byte *Payload = (Byte *)[bytesData2 bytes];
    NSData *sendData = [HSBluetoochHelper sendDataProtocol:@"0x01" Cmd:@"0x01" DataLenght:25 Payload:Payload Mask:loginMask
                                                   Useless:nil];
    [self.cbperipheral writeValue:sendData forCharacteristic:self.writeChatacteristic type:CBCharacteristicWriteWithResponse];
}

#pragma mark -- 心跳
- (void)heartbeat{
    NSData *TimeData = [HSBluetoochHelper getCurrentTime];
    Byte *Payload = (Byte *)[TimeData bytes];
    NSData *sendData = [HSBluetoochHelper sendDataProtocol:@"0x01" Cmd:@"0x02" DataLenght:15 Payload:Payload Mask:randomMask Useless:nil];
    // a88a0101 020f28bd b56a2bbf b56b45bc b16b2bbc bf1688
    [self.cbperipheral writeValue:sendData forCharacteristic:self.writeChatacteristic type:CBCharacteristicWriteWithResponse];
}

#pragma mark -- 实时充电数据上报应答,V1.0只适用于交流充电桩
- (void)uploadData{
    Byte Payload[] = {0x01};
    NSData *sendData = [HSBluetoochHelper sendDataProtocol:@"0x01" Cmd:@"0x03" DataLenght:1 Payload:Payload Mask:randomMask Useless:nil];
    [self.cbperipheral writeValue:sendData forCharacteristic:self.writeChatacteristic type:CBCharacteristicWriteWithResponse];
}

#pragma mark -- 控制指令包
- (void)controlCommandData:(Byte[])Payload{
    NSData *sendData = [HSBluetoochHelper sendDataProtocol:@"0x01" Cmd:@"0x04" DataLenght:3 Payload:Payload Mask:randomMask Useless:nil];
    [self.cbperipheral writeValue:sendData forCharacteristic:self.writeChatacteristic type:CBCharacteristicWriteWithResponse];
}

#pragma mark -- 启动或停止
- (void)openOrStop:(BOOL)isOpen{
    Byte Payload[] = {};
    if(isOpen) {
        Payload[0] = 0x01;// 启动
    }else{
        Payload[0] = 0x02;// 停止
    }
    NSData *sendData = [HSBluetoochHelper sendDataProtocol:@"0x01" Cmd:@"0x05" DataLenght:1 Payload:Payload Mask:randomMask Useless:nil];
    [self.cbperipheral writeValue:sendData forCharacteristic:self.writeChatacteristic type:CBCharacteristicWriteWithResponse];
}

#pragma mark -- 参数设置
- (void)settingParameter:(Byte[])Payload{
//    Byte Payload[] = {0x01};
    NSData *sendData = [HSBluetoochHelper sendDataProtocol:@"0x01" Cmd:@"0x06" DataLenght:43 Payload:Payload Mask:randomMask Useless:nil];
    [self.cbperipheral writeValue:sendData forCharacteristic:self.writeChatacteristic type:CBCharacteristicWriteWithResponse];
}

#pragma mark -- 参数获取
- (void)gettingParameter{
    Byte Payload[] = {0x01};
    NSData *sendData = [HSBluetoochHelper sendDataProtocol:@"0x01" Cmd:@"0x07" DataLenght:1 Payload:Payload Mask:randomMask Useless:nil];
    [self.cbperipheral writeValue:sendData forCharacteristic:self.writeChatacteristic type:CBCharacteristicWriteWithResponse];
}

#pragma mark -- 收到的蓝牙数据进行解析
- (void)analysis:(NSData *)NotifiData{
    
    if (!NotifiData) return;
    
    NSData *sumData = [NotifiData subdataWithRange:NSMakeRange(NotifiData.length - 2, 1)];
    int sum = ((Byte *)[sumData bytes])[0]; // 传进来的校验值
    NSData *sumData2 = [NotifiData subdataWithRange:NSMakeRange(0, NotifiData.length - 2)];
    Byte *bytes = (Byte *)[sumData2 bytes];
    long int sum2 = [HSBluetoochHelper checkSumWithData:bytes length:(int)sumData2.length];// 计算出来的校验值
    if (sum != sum2) return; // 判断校验值是否一致
    
    NSData *CmdData = [NotifiData subdataWithRange:NSMakeRange(4, 1)];// 消息类型
    int cmd = ((Byte *)[CmdData bytes])[0];
    
    NSData *LengthData = [NotifiData subdataWithRange:NSMakeRange(5, 1)];// 有效数据长度
    int Length = ((Byte *)[LengthData bytes])[0];
    
    NSData *PayloadData = [NotifiData subdataWithRange:NSMakeRange(6, Length)];// 有效数据
    
    NSData *analysisData;// 解密有效数据
    if (cmd == 0x01)// 是否为登录包
    {
        analysisData= [HSBluetoochHelper MaskEncryption:(Byte *)[PayloadData bytes] length:Length Mask:loginMask];
    }else
    {
        analysisData= [HSBluetoochHelper MaskEncryption:(Byte *)[PayloadData bytes] length:Length Mask:randomMask];
    }
    [self RestoreData:analysisData andCmd:cmd];
}

- (void)RestoreData:(NSData *)data andCmd:(int)cmd{
    
    if (cmd == 0x01) {// 登录包
        NSData *id_data = [data subdataWithRange:NSMakeRange(0, 18)];// 充电桩ID
        NSString *ID = [[NSString alloc] initWithData:id_data encoding:NSUTF8StringEncoding];
        
        NSData *mode_data = [data subdataWithRange:NSMakeRange(18, 1)];// 充电模式
        int mode = ((Byte *)[mode_data bytes])[0];
        
        NSData *token_data = [data subdataWithRange:NSMakeRange(19, 20)];// 序列秘钥
        NSString *token = [[NSString alloc]initWithData:token_data encoding:NSUTF8StringEncoding];
        
        [self loginToID:token_data];
        NSLog(@"充电桩ID:%@",ID);
        NSLog(@"充电模式:%i %@", mode, mode_data);
        NSLog(@"序列秘钥: %@", token);
        
        [self.ChargDictionary setObject:ID forKey:@"charg_id"];
        [self.ChargDictionary setObject:token forKey:@"token"];
    }
    else if (cmd == 0x02){// 心跳包
        NSData *state_data = [data subdataWithRange:NSMakeRange(0, 1)];// 充电桩状态
        int state = ((Byte *)[state_data bytes])[0];
        
        NSData *error_data = [data subdataWithRange:NSMakeRange(1, 1)];// 故障码
        int error = ((Byte *)[error_data bytes])[0];
        
        NSData *electric_data = [data subdataWithRange:NSMakeRange(2, 4)];// 充电桩历史充电量
        NSString *electric = [HSBluetoochHelper convertDataToHexStr:electric_data];
        unsigned long red = strtoul([electric UTF8String],0,16);
        
        NSLog(@"心跳包 %i, %i, %@ ,%lu", state, error, electric ,red);// 1, 0, 00000000
        // 心跳应答
        [self heartbeat];
    }
    else if (cmd == 0x03){
        NSData *powerEnergy_data = [data subdataWithRange:NSMakeRange(0, 4)];// 充电桩当前已充电能
        int powerEnergy = ((Byte *)[powerEnergy_data bytes])[0];

        NSData *voltage_a_data = [data subdataWithRange:NSMakeRange(4, 2)];// 充电电压Va
        int voltage_a = ((Byte *)[voltage_a_data bytes])[0];
        
        NSData *voltage_b_data = [data subdataWithRange:NSMakeRange(6, 2)];// 充电电压Vb
        int voltage_b = ((Byte *)[voltage_b_data bytes])[0];
        
        NSData *voltage_c_data = [data subdataWithRange:NSMakeRange(8, 2)];// 充电电压Vc
        int voltage_c = ((Byte *)[voltage_c_data bytes])[0];
        
        NSData *current_a_data = [data subdataWithRange:NSMakeRange(10, 2)];// 充电电流Ia
        int current_a = ((Byte *)[current_a_data bytes])[0];
        
        NSData *current_b_data = [data subdataWithRange:NSMakeRange(12, 2)];// 充电电流Ib
        int current_b = ((Byte *)[current_b_data bytes])[0];
        
        NSData *current_c_data = [data subdataWithRange:NSMakeRange(14, 2)];// 充电电流Ic
        int current_c = ((Byte *)[current_c_data bytes])[0];
        
        NSData *temperature_data = [data subdataWithRange:NSMakeRange(16, 1)];// 充电桩温度
        int temperature = ((Byte *)[temperature_data bytes])[0];
        
        NSData *time_data = [data subdataWithRange:NSMakeRange(17, 3)];// 充电时间
        int time = ((Byte *)[time_data bytes])[0];
        
        NSLog(@"%i, %i, %i, %i ,%i ,%i ,%i, %i, %i ", powerEnergy, voltage_a, voltage_b, voltage_c, current_a, current_b, current_c, temperature, time);
    }
    else if (cmd == 0x04){
        NSData * order_data = [data subdataWithRange:NSMakeRange(0, 1)];// 预约结果
        int order = ((Byte *)[order_data bytes])[0];
        
        NSLog(@"预约结果: %i", order);
    }
    else if (cmd == 0x05){
        NSData * control_data = [data subdataWithRange:NSMakeRange(0, 1)];// 控制(开/关)结果
        int control = ((Byte *)[control_data bytes])[0];
        NSLog(@"控制(开/关)结果: %i", control);
    }
    else if (cmd == 0x06){
        NSData * set_data = [data subdataWithRange:NSMakeRange(0, 1)];// 设置结果
        int set = ((Byte *)[set_data bytes])[0];
        
        NSLog(@"设置结果: %i", set);
    }
    else if (cmd == 0x07){
        NSData *id_data = [data subdataWithRange:NSMakeRange(0, 18)];// 充电桩ID
        NSString *ID = [[NSString alloc] initWithData:id_data encoding:NSUTF8StringEncoding];
        
        NSData *current_data = [data subdataWithRange:NSMakeRange(18, 1)];// 输出电流
        int currentValue = ((Byte *)[current_data bytes])[0];
        
        NSData *token_data = [data subdataWithRange:NSMakeRange(19, 20)];// 序列秘钥
        NSString *token = [[NSString alloc]initWithData:token_data encoding:NSUTF8StringEncoding];
        
        NSData *mode_data = [data subdataWithRange:NSMakeRange(39, 1)];// 充电模式
        int mode = ((Byte *)[mode_data bytes])[0];
        
        NSData *rate_data = [data subdataWithRange:NSMakeRange(40, 2)];// 充电费率
        int rate = ((Byte *)[rate_data bytes])[0];
        
        NSData *language_data = [data subdataWithRange:NSMakeRange(42, 1)];// 桩体语言设置
        int language = ((Byte *)[language_data bytes])[0];
        
        NSLog(@"读取充电桩数据： %@, %i ,%@, %i, %i, %i", ID, currentValue, token, mode, rate, language);
        
        [self.ChargDictionary setObject:ID forKey:@"charg_id"];
        [self.ChargDictionary setObject:[NSString stringWithFormat:@"%d",currentValue] forKey:@"currentValue"];
        [self.ChargDictionary setObject:token forKey:@"token"];
        [self.ChargDictionary setObject:[NSString stringWithFormat:@"%d",mode] forKey:@"mode"];
        [self.ChargDictionary setObject:[NSString stringWithFormat:@"%d",rate] forKey:@"rate"];
        [self.ChargDictionary setObject:[NSString stringWithFormat:@"%d",language] forKey:@"language"];
    }
}



/**
 设置定时预约
 
 @param isAppointment 是否预约  0x01表示预约，0x00取消预约
 @param time 预约时间 30min，等待预约时间后启动启动充电。最长预约8小时
 */
- (void)makeAppointment:(BOOL)isAppointment Time:(int)time
{
    Byte Payload[] = {};
    if (isAppointment) {
        Payload[0] = 0x01;
    }else{
        Payload[0] = 0x02;
    }
    NSString *str = [HSBluetoochHelper ToHex2:time];
    NSString *str1 = [str substringWithRange:NSMakeRange(0, 2)];
    NSString *str2 = [str substringWithRange:NSMakeRange(2, 2)];
    Payload[1] = strtoul([str1 UTF8String], 0, 16) ;
    Payload[2] = strtoul([str2 UTF8String], 0, 16) ;
    NSData *payloadData = [NSMutableData dataWithBytes:Payload length:3];
    
    [self controlCommandData:(Byte*)[payloadData bytes]];
}

/**
 参数设置
 
 @param Charg_ID 充电桩ID
 @param currentVaule 输出电流大小
 @param token_ID 秘钥序列
 @param mode 充电模式
 @param rate 充电费率
 @param language 语言设置
 */
- (void)setChargingpileID:(NSString *)Charg_ID currentVaule:(int)currentVaule token_ID:(NSString *)token_ID mode:(int)mode rate:(int)rate language:(int)language{
    
    NSMutableData *BytesData = [[NSMutableData alloc]initWithData:[HSBluetoochHelper dataWithString:Charg_ID]];
    
    Byte currentByte[] = {};
    currentByte[0] = strtoul([[HSBluetoochHelper ToHex:currentVaule] UTF8String], 0, 16);
    [BytesData appendBytes:currentByte length:1];
    
    if ([token_ID isEqualToString:@""]) token_ID = self.ChargDictionary[@"token"];
    [BytesData appendData:[HSBluetoochHelper dataWithString:token_ID]];
    
    Byte byte[4] = {};
    byte[0] = strtoul([[HSBluetoochHelper ToHex:mode] UTF8String], 0, 16);
    
    NSString *str = [HSBluetoochHelper ToHex2:rate];
    NSString *str1 = [str substringWithRange:NSMakeRange(0, 2)];
    if (str.length == 2) { // 判断长度
        byte[1] = 0x00 ;
        byte[2] = strtoul([str1 UTF8String], 0, 16) ;
    }else{
        NSString *str2 = [str substringWithRange:NSMakeRange(2, 2)];
        byte[1] = strtoul([str1 UTF8String], 0, 16) ;
        byte[2] = strtoul([str2 UTF8String], 0, 16) ;
    }
    
    byte[3] = strtoul([[HSBluetoochHelper ToHex:language] UTF8String], 0, 16);
    
    [BytesData appendBytes:byte length:4];
    
    [self settingParameter:(Byte*)[BytesData bytes]];
}


@end

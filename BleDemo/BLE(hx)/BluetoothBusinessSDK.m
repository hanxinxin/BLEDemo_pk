//
//  BluetoothSDK.m
//  BleDemo
//
//  Created by mac on 2020/1/15.
//  Copyright © 2020 mac. All rights reserved.
//

#import "BluetoothBusinessSDK.h"
#import "PakpoboxBLE.h"


@interface BluetoothBusinessSDK ()

@property (nonatomic,strong)NSString * macAddressStr;
@property (nonatomic,strong)NSString * siteIdStr;
@end


@implementation BluetoothBusinessSDK

//+(void)shareBluetoothSDK
//{
//    
//}
/// 设置appkey
/// @param Key 后台请求的key
+(void)SetAppkey:(NSString*)Key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:Key forKey:@"Appkey"];
    
}
-(void)getServerAppKey:(NSString *)siteSerialNumber
{
    
//    NSArray * arr=@[@[HeaderkeyOne,HeaderkeyOne1],@[HeaderkeyTwo,HeaderkeyTwo1]];
    
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:HeadArray UrlStr:[NSString stringWithFormat:@"%@%@%@",ServerPakp,GetAppKeyUrl,siteSerialNumber] parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"getServerAppKey responseObject == %@",responseObject);
        NSDictionary * dict = (NSDictionary *)responseObject;
        NSString *macAddress=[dict objectForKey:@"macAddress"];
        NSString *siteId=[dict objectForKey:@"siteId"];
        NSArray * array =[dict objectForKey:@"secretKeyList"];
        for (int i =0; i<array.count; i++) {
            NSDictionary *DList=array[i];
//            NSString *creationTime=[DList objectForKey:@"creationTime"];
            NSString *secretKey=[DList objectForKey:@"secretKey"];
            [[NSUserDefaults standardUserDefaults] setObject:secretKey forKey:@"CSKeystr"];
        }
        self.macAddressStr=macAddress;
        self.siteIdStr=siteId;
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error == %@",error);
    }];
}

/// 快递员登录
/// @param Name 用户的name
/// @param Word 用户的password
+(NSInteger)CourierLogin:(NSString*)Name Word:(NSString*)Word
{
    static NSInteger Restart=0;
    NSDictionary*dict = @{@"username":Name,
                          @"password":Word,
    };
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:HeadArray UrlStr:[NSString stringWithFormat:@"%@%@",ServerPakp,LoginPakp] parameters:dict progress:^(id progress) {
        
    } Success:^(NSInteger statusCode, id responseObject) {
        NSLog(@"LoginPakp  == %@",responseObject);
        NSDictionary * RDict = (NSDictionary*)responseObject;
//        NSString * tokenStr = [RDict objectForKey:@"token"];
        NSString * errorCode =  [RDict objectForKey:@"errorCode"];
        if(errorCode!=nil)
        {
            
        }else if([errorCode intValue]==-1)
        {
            
            Restart = -1;
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error == %@",error);
    }];
    return Restart;
}

/// 验证运单号
/// @param expressNumber 运单号
/// @param siteSerialNumber 格口的信息
+(NSInteger)MerchantCheckCode:(NSString*)expressNumber siteSerialNumber:(NSString*)siteSerialNumber;
{
    static NSInteger Restart=0;
    NSString * Headerkey1 =@"X-LOCKER-ACCESS-KEY";
    NSString * Headerkey2 =@"X-USER-TOKEN";
    NSDictionary*dict = @{@"expressNumber":@"",
    };
    NSArray * arr=@[@[Appkey,Headerkey1],@[@"",Headerkey2]];
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:arr UrlStr:ServerPakp parameters:dict progress:^(id progress) {
        
    } Success:^(NSInteger statusCode, id responseObject) {
        NSDictionary * RDict = (NSDictionary*)responseObject;
//        NSString * tokenStr = [RDict objectForKey:@"token"];
        NSString * errorCode =  [RDict objectForKey:@"errorCode"];
        if(errorCode!=nil)
        {
            
        }else if([errorCode intValue]==-1)
        {
            
            Restart = -1;
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        
    }];
    return Restart;
}


/// 上传存件信息 /*同步商户存件信息*/
/// @param dictS 格口的信息
-(void)TBmerchantStoreExpress:(NSDictionary*)dictS
{
 
    NSString * Headerkey =@"X-USER-TOKEN";

    NSArray * arr=@[@[Appkey,Headerkey]];
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:arr UrlStr:[NSString stringWithFormat:@"%@%@",ServerPakp,C_MerchantStoreExpress] parameters:dictS progress:^(id progress) {
        
    } Success:^(NSInteger statusCode, id responseObject) {
        NSDictionary * RDict = (NSDictionary*)responseObject;
//        NSString * tokenStr = [RDict objectForKey:@"token"];
        NSString * errorCode =  [RDict objectForKey:@"errorCode"];
        if(errorCode!=nil)
        {
            
        }else if([errorCode intValue]==-1)
        {
            
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        
    }];
}



/// 打开格口
+(NSInteger)OpenCabinet
{
    return 0;
}






/// 取件
/// @param Code 验证码
/// @param BoxInformation 箱子信息
+(NSInteger)PickupVerification:(NSString*)Code BoxInformation:(NSString*)BoxInformation
{
    return 0;
}


-(void)TBmerchantTakeExpress
{
       NSString * Headerkey1 =@"X-LOCKER-ACCESS-KEY";
       NSString * Headerkey2 =@"X-USER-TOKEN";
       NSDictionary*dict = @{@"expressNumber":@"",
       };
       NSArray * arr=@[@[Appkey,Headerkey1],@[@"",Headerkey2]];
       [[AFNetWrokingAssistant shareAssistant] PostURL_Token:arr UrlStr:[NSString stringWithFormat:@"%@%@",ServerPakp,Q_MerchantTakeExpress] parameters:dict progress:^(id progress) {
           
       } Success:^(NSInteger statusCode, id responseObject) {
           NSDictionary * RDict = (NSDictionary*)responseObject;
//           NSString * tokenStr = [RDict objectForKey:@"token"];
           NSString * errorCode =  [RDict objectForKey:@"errorCode"];
           if(errorCode!=nil)
           {
               
           }else if([errorCode intValue]==-1)
           {
               
           }
           
       } failure:^(NSInteger statusCode, NSError *error) {
           
       }];
}


/// 提交开锁用的密钥信息
/// @param dictS 格口的信息
//1    siteId    Y    string    获取密钥时下发的 SiteId
//1    secretKey    Y    string    本次开门使用的密钥
//"siteId":"eef25eb7-bf1d-48c0-8c76-45ced3a1ac78",
//"secretKey":"C1071263A90561A50918C1071263A90561A50918F07F579765DB"
-(void)PostOpenLockKeyBLE:(NSDictionary*)dictS
{
    
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:nil UrlStr:[NSString stringWithFormat:@"%@%@",ServerPakp,PostOpenLockKey] parameters:dictS progress:^(id progress) {
        
    } Success:^(NSInteger statusCode, id responseObject) {
        NSDictionary * RDict = (NSDictionary*)responseObject;
//        NSString * tokenStr = [RDict objectForKey:@"token"];
        NSString * errorCode =  [RDict objectForKey:@"errorCode"];
        if(errorCode!=nil)
        {
            
        }else if([errorCode intValue]==-1)
        {
            
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        
    }];
}


-(void)GetQuJianInfoBle:(NSString*)siteSerialNumber pinCode:(NSString*)pinCode
{

    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL_token:nil UrlStr:[NSString stringWithFormat:@"%@%@?siteSerialNumber=%@&pinCode=%@",ServerPakp,GetQuJianInfo,siteSerialNumber,pinCode] parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        
        
    } failure:^(NSInteger statusCode, NSError *error) {
        
    }];
}
@end

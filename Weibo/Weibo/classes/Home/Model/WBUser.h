//
//  WBUser.h
//  Weibo
//
//  Created by lbq on 16/1/5.
//  Copyright © 2016年 linbq-b7. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBUser : NSObject

/** idstr	string	字符串型的用户UID */
@property (nonatomic ,copy)  NSString *idstr;

/**  screen_name	string	用户昵称 */
@property (nonatomic ,copy)  NSString *screen_name;

/** name	string	友好显示名称 */
@property (nonatomic ,copy)  NSString *name;

/** province   int	用户所在省级ID */
@property (nonatomic ,copy)  NSNumber *province;

/** city	int	用户所在城市ID */
@property (nonatomic ,copy)  NSNumber *city;

/** location	string	用户所在地 */
@property (nonatomic ,copy)  NSString *location;

/** description	string	用户个人描述 主意:接口api属性名为description,避免跟关键字冲突,加上str,在MJExtension中调用方法,将description赋值给descriptionstr*/
@property (nonatomic ,copy)  NSString *descriptionstr;

/** url	string	用户博客地址 */
@property (nonatomic ,copy)  NSString *url;

/** profile_image_url	string	用户头像地址（中图），50×50像素 */
@property (nonatomic ,copy)  NSString *profile_image_url;

/** profile_url	string	用户的微博统一URL地址 */
@property (nonatomic ,copy)  NSString *profile_url;

/** domain	string	用户的个性化域名 */
@property (nonatomic ,copy)  NSString *domain;

/** weihao	string	用户的微号 */
@property (nonatomic ,copy)  NSString *weihao;

/** gender	string	性别，m：男、f：女、n：未知 */
@property (nonatomic ,copy)  NSString *gender;

/** followers_count	int	粉丝数 */
@property (nonatomic ,copy)  NSNumber *followers_count;

/** friends_count	int	关注数 */
@property (nonatomic ,copy)  NSNumber *friends_count;

/** statuses_count	int	微博数 */
@property (nonatomic ,copy)  NSNumber *statuses_count;

/** favourites_count	int	收藏数 */
@property (nonatomic ,copy)  NSNumber *favourites_count;

/** created_at	string	用户创建（注册）时间 */
@property (nonatomic ,copy)  NSString *created_at;

/** avatar_large	string	用户头像地址（大图），180×180像素 */
@property (nonatomic ,copy)  NSString *avatar_large;

/** avatar_hd	string	用户头像地址（高清），高清头像原图 */
@property (nonatomic ,copy)  NSString *avatar_hd;

/** verified_reason	string	认证原因 */
@property (nonatomic ,copy)  NSString *verified_reason;

/** online_status	int	用户的在线状态，0：不在线、1：在线 */
@property (nonatomic ,copy)  NSNumber *online_status;

/** bi_followers_count	int	用户的互粉数 */
@property (nonatomic ,copy)  NSNumber *bi_followers_count;

/** lang	string	用户当前的语言版本，zh-cn：简体中文，zh-tw：繁体中文，en：英语 */
@property (nonatomic ,copy)  NSString *lang;

/** 会员类型 >2 才是VIP*/
@property (nonatomic ,assign)  int mbtype;

/** 会员等级 */
@property (nonatomic ,assign)  int mbrank;

/** 是否是vip */
@property (nonatomic ,assign)  BOOL vip;


/**
 *
 未实行转模型的属性
 following	boolean	暂未支持
 allow_all_act_msg	boolean	是否允许所有人给我发私信，true：是，false：否
 geo_enabled	boolean	是否允许标识用户的地理位置，true：是，false：否
 verified	boolean	是否是微博认证用户，即加V用户，true：是，false：否
 verified_type	int	暂未支持
 remark	string	用户备注信息，只有在查询用户关系时才返回此字段
 status	object	用户的最近一条微博信息字段 详细
 allow_all_comment	boolean	是否允许所有人对我的微博进行评论，true：是，false：否

 follow_me	boolean	该用户是否关注当前登录用户，true：是，false：否

 */
@end

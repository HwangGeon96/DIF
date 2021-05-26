package com.dif.foodsearch.com.dao;

import com.dif.foodsearch.vo.UserVO;

public interface SUserMapper {

	UserVO localSignIn(String id);

	UserVO socialLogin(UserVO re);

	int socialSignIn(UserVO re);

}

package com.dif.foodsearch.com.dao;

import com.dif.foodsearch.vo.UserVO;

public interface UserMapper {

	int SignUp(UserVO newUser);

	String login(UserVO loginUser);

	String idCheck(String user_ID);

}

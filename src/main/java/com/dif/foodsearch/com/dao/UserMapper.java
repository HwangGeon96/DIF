package com.dif.foodsearch.com.dao;

import java.util.ArrayList;
import java.util.HashMap;

import com.dif.foodsearch.vo.UserVO;
import com.dif.foodsearch.vo.favoriteVO;

public interface UserMapper {

	int SignUp(UserVO newUser);

	String idCheck(String user_ID);

	int updateSnsInfo(UserVO result);

	int updateInfo(UserVO result);

	int updateInfoPw(UserVO result);

	UserVO getInfo(String user_ID);

	int deleteUser(String user_ID);

	int favorite(favoriteVO vo);

	int delfavorite(favoriteVO vo);

	ArrayList<favoriteVO> getfavorite(String id);

	favoriteVO check(favoriteVO vo);

}

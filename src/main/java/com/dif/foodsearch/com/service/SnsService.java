package com.dif.foodsearch.com.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dif.foodsearch.com.dao.SnsDao;
import com.dif.foodsearch.utill.MakeId;
import com.dif.foodsearch.vo.UserVO;



@Service
public class SnsService {
	
	@Autowired
	private SnsDao dao;

	public UserVO localSignIn(String id, String pwd) {
		
		return dao.localSignIn(id, pwd);
	}

	public UserVO socialLogin(String nickname, String email, String pw) {
		String id = new MakeId().toString();
		UserVO result = new UserVO();
		
		result.setUser_ID(id);
		result.setUser_PW(pw);
		result.setUser_NickName(nickname);
		result.setUser_Email(email);
		
		result = dao.socialLogin(result);
		
		return result;
	}

}

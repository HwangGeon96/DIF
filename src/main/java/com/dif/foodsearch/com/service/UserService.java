package com.dif.foodsearch.com.service;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dif.foodsearch.com.dao.UserDAO;
import com.dif.foodsearch.vo.UserVO;


@Service
public class UserService {
	
	@Autowired
	UserDAO dao;

	public boolean SignUp(String user_ID, String user_PW, String user_Email, String user_NickName) {
		UserVO newUser = new UserVO();
		newUser.setUser_ID(user_ID);
		newUser.setUser_PW(user_PW);
		newUser.setUser_Email(user_Email);
		newUser.setUser_NickName(user_NickName);
		int result = dao.SignUp(newUser);
		
		switch (result) {
		case 1:
			return true;
		default:
			return false;
		}
	}
	public String login(String user_ID, String user_PW) {
		UserVO loginUser = new UserVO();
		loginUser.setUser_ID(user_ID);
		loginUser.setUser_PW(user_PW);
		
		
		String result = dao.login(loginUser);
		
		return result;
	}
	public String idCheck(String user_ID) {
		// TODO Auto-generated method stub
		return dao.idCheck(user_ID);
	}
	public void Modify(UserVO vo) {
		
		dao.Modify(vo);
		
	}
	
	public void Withdrawl(UserVO vo) {
		dao.Withdrawl(vo);
	}
	
	
}

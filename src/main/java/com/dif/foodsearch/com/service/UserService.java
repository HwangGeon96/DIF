package com.dif.foodsearch.com.service;


import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.dif.foodsearch.com.dao.UserDAO;
import com.dif.foodsearch.vo.UserVO;
import com.dif.foodsearch.vo.favoriteVO;


@Service
public class UserService {
	
	@Autowired
	UserDAO dao;
	
	@Autowired
	BCryptPasswordEncoder pwdEncoder;

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
	
	public String idCheck(String user_ID) {
		// TODO Auto-generated method stub
		return dao.idCheck(user_ID);
	}

	public UserVO updateInfo(UserVO result) {
		String pw = result.getUser_PW();
		
		if(pw.equals("소셜로그인이용자입니다")==false&&pw.length()>3) {
			result.setUser_PW(pwdEncoder.encode(pw));
		}
		
		return dao.updateInfo(result);
	}

	public boolean deleteUser(String user_ID) {
		int result = dao.deleteUser(user_ID);
		
		if(result>0) {
			return true;
		}
		
		return false;
	}

	public favoriteVO favorite(String name, String link, String id) {
			favoriteVO vo = new favoriteVO();
			vo.setName(name);
			vo.setLink(link);
			vo.setId(id);
			
			favoriteVO result = dao.favorite(vo);
			
		return result;
	}

	public ArrayList<favoriteVO> getfavorite(String id) {
		
		return dao.getfavorite(id);
	}
	
}

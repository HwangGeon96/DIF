package com.dif.foodsearch.com.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.dif.foodsearch.vo.UserVO;

@Repository
public class UserDAO {

	@Autowired
	SqlSession session;
	public int SignUp(UserVO newUser) {
        int result = 0;
		
		try {
			UserMapper mapper = session.getMapper(UserMapper.class);
			result = mapper.SignUp(newUser);
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	public String login(UserVO loginUser) {
        String result = null;
		
		try {
			UserMapper mapper = session.getMapper(UserMapper.class);
			result = mapper.login(loginUser);
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	public String idCheck(String user_ID) {
		String result = null;
		
		try {
			UserMapper mapper = session.getMapper(UserMapper.class);
			result = mapper.idCheck(user_ID);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	public void Modify(UserVO vo) {
		
		session.update("UserMapper.Modify", vo);
		
	}
	
	public void Withdrawl(UserVO vo) {
		
		session.delete("UserMapper.Withdrawl", vo);
	}

}

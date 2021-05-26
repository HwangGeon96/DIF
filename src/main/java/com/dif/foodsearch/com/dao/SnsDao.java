package com.dif.foodsearch.com.dao;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Repository;

import com.dif.foodsearch.controller.UserController;
import com.dif.foodsearch.vo.UserVO;

@Repository
public class SnsDao {
	private static final Logger logger = LoggerFactory.getLogger(SnsDao.class);
	@Autowired
	BCryptPasswordEncoder pwdEncoder;
	
	@Autowired
	private SqlSession session;
	
	public UserVO localSignIn(String id, String pwd) {
			UserVO result = null;
		try {
			SUserMapper mapper = session.getMapper(SUserMapper.class);
			result = mapper.localSignIn(id);
			Boolean check = pwdEncoder.matches(pwd, result.getUser_PW());
			
			if(check) {
				result.setUser_PW("");
			}else {
				result.setUser_ID("n");
				result.setUser_PW("");
				result.setUser_NickName("");
				result.setUser_Email("");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			
		}
		return result;
	}

	public UserVO socialLogin(UserVO re) {
		UserVO result = null;
		
		try {
			SUserMapper mapper = session.getMapper(SUserMapper.class);
			result = mapper.socialLogin(re);
			
			if(result==null) {
				mapper.socialSignIn(re);
				result = mapper.socialLogin(re);
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
			
		}
		return result;
	}

}

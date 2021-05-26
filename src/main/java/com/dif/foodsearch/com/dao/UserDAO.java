package com.dif.foodsearch.com.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.dif.foodsearch.vo.UserVO;
import com.dif.foodsearch.vo.favoriteVO;

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

	public UserVO updateInfo(UserVO result) {
		UserVO rt = null;
		String pw = result.getUser_PW();
		try {
			UserMapper mapper = session.getMapper(UserMapper.class);
			
			if(pw.equals("소셜로그인이용자입니다")) {
				int up = mapper.updateSnsInfo(result);
				rt = mapper.getInfo(result.getUser_ID());
				
				if(up<1) {
					rt.setUser_PW("nn");
				}
				
			}else if(pw.length()<1) {
				int up = mapper.updateInfo(result);
				rt = mapper.getInfo(result.getUser_ID());
				rt.setUser_PW("");
				
				if(up<1) {
					rt.setUser_PW("n");
				}
			}else {
				int up = mapper.updateInfoPw(result);
				rt = mapper.getInfo(result.getUser_ID());
				rt.setUser_PW("");
				
				if(up<1) {
					rt.setUser_PW("n");
				}
			}
			
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return rt;
	}

	public int deleteUser(String user_ID) {
		int result = 0;
		
		try {
			UserMapper mapper = session.getMapper(UserMapper.class);
			result = mapper.deleteUser(user_ID);
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	public favoriteVO favorite(favoriteVO vo) {
		int re = 0;
		favoriteVO result = null;
		
		try {
			UserMapper mapper = session.getMapper(UserMapper.class);
			result = mapper.check(vo);
			
			if(result == null) {
				re = mapper.favorite(vo);
				result = mapper.check(vo);
				if(re>0) {
					result.setResult("y");
					result.setIcon("/resources/icons/impStar.png");
				}else {
					result.setResult("n");
					result.setIcon("/resources/icons/unImpStar.png");
				}
				
			}else {
				re = mapper.delfavorite(vo);

				if(re>0) {
					result.setResult("y");
					result.setIcon("/resources/icons/unImpStar.png");
				}else {
					result.setResult("n");
					result.setIcon("/resources/icons/impStar.png");
				}
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	public ArrayList<favoriteVO> getfavorite(String id) {
		ArrayList<favoriteVO> result = null;
		
		try {
			UserMapper mapper = session.getMapper(UserMapper.class);
			result = mapper.getfavorite(id);
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

}

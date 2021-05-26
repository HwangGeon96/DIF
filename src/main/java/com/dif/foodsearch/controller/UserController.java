package com.dif.foodsearch.controller;


import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.dif.foodsearch.com.service.UserService;
import com.dif.foodsearch.vo.UserVO;
import com.dif.foodsearch.vo.favoriteVO;


@Controller
@RequestMapping(value = "/user")
public class UserController {
	private static final Logger logger = LoggerFactory.getLogger(UserController.class);
	@Autowired
	UserService service;
	
	@Autowired
	BCryptPasswordEncoder pwdEncoder;
	
	@RequestMapping (value = "/SignUp", method = RequestMethod.GET)
	public String SignUp() {
		return "/user/SignUp";
	}
	
	@RequestMapping (value = "/SignUp", method = RequestMethod.POST)
	public String SignUp(String user_ID, String user_PW, String user_Email, String user_NickName) {
		logger.info("비밀번호"+user_PW);
		String pw = pwdEncoder.encode(user_PW);
		boolean result = service.SignUp(user_ID, pw, user_Email, user_NickName);
	    if (result) {
	    	System.out.println("입력 성공");
	    	return "redirect:/";
	    }else {
	    	 System.out.println("입력 실패");
	    	return "redirect:/user/SignUp";
	    }
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/idCheck",method = RequestMethod.POST)
	public String idCheck(String userId) {
		logger.info("값은:"+userId);
		String idCheck = service.idCheck(userId);
		
		String result = "yes";
		if(idCheck != null) {
			result = "no";
		}
		
		return result;
	}
	
	@RequestMapping (value = "/mypage", method = RequestMethod.GET)
	public String mypage() {
		return "/user/mypage";
	}
	
	@RequestMapping (value = "/mypage", method = RequestMethod.POST)
	public String mypage(String user_ID, String user_PW, String user_Email, String user_NickName, HttpSession session, RedirectAttributes redirect) {
		UserVO result = new UserVO();
		
		result.setUser_ID(user_ID);
		result.setUser_PW(user_PW);
		result.setUser_Email(user_Email);
		result.setUser_NickName(user_NickName);
		logger.info("업데이트 메소드"+user_ID,user_PW,user_Email,user_NickName);
		
		result = service.updateInfo(result);
		
		if(result.getUser_PW().equals("nn")||result.getUser_PW().equals("n")) {
			session.setAttribute("user", result);
			redirect.addFlashAttribute("result", 2); 
			
			return "redirect:/user/mypage";
		}
		
		session.setAttribute("user", result);
		redirect.addFlashAttribute("result", 1); 
		
		
		
		return "redirect:/";
	}
	
	@RequestMapping (value = "/deleteUser", method = RequestMethod.GET)
	public String deleteUser(HttpSession session,RedirectAttributes redirect) {
		UserVO id = (UserVO)session.getAttribute("user");
		
		boolean result = service.deleteUser(id.getUser_ID());
		
		if(result) {
			session.invalidate();
			return "redirect:/";
		}
		redirect.addFlashAttribute("result", 3);  

		return "redirect:/user/mypage";
	}
	
	@ResponseBody
	@RequestMapping (value = "/favorite", method = RequestMethod.POST)
	public favoriteVO favorite(String name, String link, String id) {
		
		favoriteVO result = service.favorite(name, link, id); 
		
		return result;
	}
	
	@ResponseBody
	@RequestMapping (value = "/getfavorite", method = RequestMethod.POST)
	public ArrayList<favoriteVO> getfavorite(String id) {
		
		ArrayList<favoriteVO> result = service.getfavorite(id);

		return result;
	}

	@RequestMapping (value = "/favor", method = RequestMethod.GET)
	public String favor() {
		return "/user/favor";
	}
}

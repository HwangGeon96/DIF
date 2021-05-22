package com.dif.foodsearch.controller;


import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.dif.foodsearch.com.service.UserService;
import com.dif.foodsearch.vo.UserVO;


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
		
		String idCheck = service.idCheck(userId);
		
		String result = "yes";
		if(idCheck != null) {
			result = "no";
		}
		
		return result;
	}

	
	@RequestMapping (value = "/login", method = RequestMethod.GET)
	public String login() {
		return "/user/login";
	}
	
	@RequestMapping (value = "/login", method = RequestMethod.POST)
	public String login(String user_ID, String user_PW, HttpSession session) {
		String loginId = service.login(user_ID, user_PW);
		
		if(loginId == null) {
			System.out.println("로그인 실패");
			return "redirect:/user/login";
		}else {
			System.out.println("로그인 성공");
			session.setAttribute("user_ID", loginId);
			
			return "redirect:/";
		}
		
	}
	
	@RequestMapping (value = "/logout", method = RequestMethod.GET)
	public String logout(HttpSession session) {
		session.removeAttribute("user_ID");
		
		return "redirect:/";
	}
	
	@RequestMapping (value = "/mypage", method = RequestMethod.GET)
	public String mypage() {
		
		
		return "/user/mypage";
	}
	
	@RequestMapping (value = "/Modify", method = RequestMethod.POST)
	public String Modify(UserVO vo, HttpSession session) {

		service.Modify(vo);
		
		session.invalidate();
		
		return "redirect:/";
	}
	
	@RequestMapping (value = "/Withdrawl", method = RequestMethod.GET)
	public String Withdrawl() {
		
		
		return "/user/Withdrawl";
	}
	
	@RequestMapping (value = "/Withdrawl", method = RequestMethod.POST)
	public String Withdrawl(UserVO vo, HttpSession session, RedirectAttributes rttr) {
		// 세션에 있는 member를 가져와 member변수에 넣어줍니다.
		        UserVO user = (UserVO) session.getAttribute("user");
				// 세션에있는 비밀번호
				String sessionPass = user.getUser_PW();
				// vo로 들어오는 비밀번호
				String voPass = vo.getUser_PW();
				
				if(!(sessionPass.equals(voPass))) {
					rttr.addFlashAttribute("msg", false);
					return "redirect:/user/Withdrawl";
				}
				service.Withdrawl(vo);
				session.invalidate();
				return "redirect:/";
	}


}

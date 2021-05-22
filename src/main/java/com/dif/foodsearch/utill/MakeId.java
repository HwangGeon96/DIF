package com.dif.foodsearch.utill;

import java.util.ArrayList;
import java.util.Random;

public class MakeId {
	private Random rd = new Random();
	private String[] list0 = {"a","b","c","d","e","f","g","h","i","j"};
	private String[] list1 = {"k","l","m","n","o","p","q","r","s","t"};
	private String[] list2 = {"u","v","w","x","y","z","!","@","#","$"};
	private String[] list3 = {"0","1","2","3","4","5","6","7","8","9"};
	private ArrayList<String[]> idList= new ArrayList<String[]>();
	private int lenID = 10;
	
	
	public String MakeId() {
		idList.add(list0);
		idList.add(list1);
		idList.add(list2);
		idList.add(list3);
		String ID = "";
		
		for(int i=0;i<lenID;i++) {
			int selectList = rd.nextInt(idList.size());
			int selectChar = rd.nextInt(lenID);
			int selectUpper = rd.nextInt(2);
			
			
			if(selectUpper<1) {
				ID += idList.get(selectList)[selectChar].toUpperCase();
			}else {
				ID += idList.get(selectList)[selectChar];
			}
		}
		return ID;
	}


	@Override
	public String toString() {
		return MakeId();
	}
	
	
}

package org.home.gae.common;

public class ShoppingUtil {
	
public static boolean isNumber(String potenialNumber) {
	try {
		//TODO cut off leading and following spaces 
		Integer.parseInt(potenialNumber);
		return true;
	} catch(NumberFormatException ex) {
		//TODO loging
		return false;
	}
}

public static boolean checkIfEmptyOrNull(String s) {
    if (s == null) {
       return true;
    }
    
    if (s.trim().length()==0) {
       return true;
    }
    
    return false;
  }

}

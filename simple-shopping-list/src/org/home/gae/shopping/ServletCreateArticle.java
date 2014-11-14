package org.home.gae.shopping;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.home.gae.common.ShoppingUtil;
import org.home.gae.shopping.dao.Dao;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import static org.home.gae.common.ShoppingUtil.isNumber;
import static org.home.gae.common.ShoppingUtil.checkIfEmptyOrNull;

@SuppressWarnings("serial")
public class ServletCreateArticle extends HttpServlet {
  
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws IOException, ServletException {
    System.out.println("Creating new article ");
    User user = (User) req.getAttribute("user");
    if (user == null) {
      UserService userService = UserServiceFactory.getUserService();
      user = userService.getCurrentUser();
    }
    
    if (checkIfInputDataAreValid(req, req.getParameter("name"), req.getParameter("amount"))) {
    	Dao.INSTANCE.add(user.getUserId(), 
    			req.getParameter("name"), 
    			new Integer(req.getParameter("amount")));
    	resp.sendRedirect("/ShoppingApplication.jsp");
    } else {
    	req.getRequestDispatcher("/ShoppingApplication.jsp").forward(req, resp);
    }

  }

	private boolean checkIfInputDataAreValid(HttpServletRequest req,
			String name, String amount) {
		if (checkIfEmptyOrNull(name)) {
			req.setAttribute("error_", "Name of the article can't be empty!");
			return false;
		}
		if (checkIfEmptyOrNull(amount)) {
			req.setAttribute("error_", "Amount can't be empty!");
			return false;
		}
		if (!isNumber(amount.trim())) {
			req.setAttribute("error_", "Amount must be a number!");
			return false;
		}		
		return true;

	}

}


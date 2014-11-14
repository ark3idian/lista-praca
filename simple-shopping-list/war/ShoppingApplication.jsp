<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="org.home.gae.shopping.model.Article" %>
<%@ page import="org.home.gae.shopping.dao.Dao" %>

<!DOCTYPE html>


<%@page import="java.util.ArrayList"%>

<html>
  <head>  
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Shopping list">
    <meta name="author" content="Rafal Wdowiak">
    <link rel="icon" href="../../favicon.ico">

    <title>Shopping list</title>

    <!-- Bootstrap core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap theme -->
    <link href="css/bootstrap-theme.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="theme.css" rel="stylesheet">

    <!--
    <link href="css/main.css" rel="stylesheet">
    -->
        <script type="text/javascript">
			
			String.prototype.trim = function() {
			   return this.replace(/^\s+|\s+$/g,"");
			}
			
            function validate()
            {
                var amount = document.getElementById("amount");
             	
                if (amount == null) {
                	alert("Amount is mandatory. Please enter a number.")
                	return false;
                }
				
				if (amount.value.trim() == "") {
					alert("Amount can't be empty. Please enter a number.");
					return false;
				}
				
				if ((amount.value<1) || (amount.value>99)) {
				    alert("Invalid amount. Please provide a number between 1 and 99.");
					return false;
				}
                
                if(isNaN(amount.value)){
                    alert("Invalid amount. Please enter a number");
                    return false;
                }
                return true;
            };
        </script>      
  </head>
  <body role="document">

  <%
	Dao dao = Dao.INSTANCE;
	
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	
	String url = userService.createLoginURL(request.getRequestURI());
	String urlLinktext = "Login";
	List<Article> articles = new ArrayList<Article>();
	            
	if (user != null){
	    url = userService.createLogoutURL(request.getRequestURI());
	    urlLinktext = "Logout";
	    articles = dao.getArticles(user.getUserId());
	}
	String error = (String)request.getAttribute("error_");
	    
   %>

  
    <!-- Fixed navbar -->
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#">Shopping List</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav">
            <li class="active"><a href="#">Home</a></li>
            <li><a href="#about">About</a></li>
            <li><a href="#contact">Contact</a></li>
            <li>
               <a href="<%=url%>"><%=urlLinktext%> <%=(user==null? "" : user.getNickname())%></a>
            </li>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </nav>
    </br></br></br>
      

  <div class="container theme-showcase" role="main">
    <% if (user != null){ %>
	<div class="jumbotron">
	        <h1>Hello, <%=user%></h1>
	        <p>Please add some articles to your shopping list. The ordered articles will be delivered to you so soon as possible!</p>
        	<p>You have a total number of <%= articles.size() %>  articles. </p>	
	</div>
    <% if (error != null){ %>	
		<div class="alert alert-danger" role="alert">
	        <strong><%=error%></strong>
	    </div>
    <%}%>
    <div class="page-header">
        <h1>Ordered articles</h1>
    </div>
    <div class="row">
    <div class="col-md-6">
	        <table class="table table-striped">
	        <tr>
	          <th>Name</th>
	          <th>Amount</th>
	          <th>&nbsp;</th>
	        </tr>
	  		<% for (Article article : articles) {%>
				<tr> 
					<td><%=article.getName()%></td>
					<td><%=article.getAmount()%></td>
					<td><a class="done" href="/done?id=<%=article.getId()%>" >Delete</a></td>
				</tr> 
			<%}%>
	        </table>
	</div>       
	</div>
    <div class="page-header">
        <h1>Add a new article</h1>
    </div>
    
	<div class="container">

      <form class="form-signin" role="form" action="/new" method="post" accept-charset="utf-8" onsubmit="return validate();">
        <input type="text" class="form-control" placeholder="Enter a article name" required name="name" id="name">
        <input type="text" class="form-control" placeholder="Enter a amount of articles" required name="amount" id="amount" size=3>    
        <button class="btn btn-lg btn-primary btn-block" type="submit">Add</button>
      </form>
      </br></br></br>

    </div> <!-- /container -->
	
	
	<% }else{ %>
	<p> Please login with your Google account</p>
	
	<% } %>  
	
</div>  

</body>
</html> 
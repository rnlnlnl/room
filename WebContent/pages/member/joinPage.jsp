<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- JSTL의 CORE라이브러리에 속한 태그들을 사용 하기 위해 링크 작성 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%-- 컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="joinPageForm">
<img alt="welcome" src="${contextPath}/css/imgLogo/welcome.png">
<h1>&nbsp;</h1>
	<h1>ROOMDY에 오신걸 환영합니다.</h1>
	
	<h5>회원 가입시 유의사항</h5>
	
	<div>
		※저희 제품은 고객님께서 주문하는 즉시 생산을 시작하여 다소 시간이 걸릴수있습니다.
		<br> 
		※인증에 문제가 있을 경우,<br>
		<b>ROOMDY정보㈜ 고객센터(070-2020-0214/test.skin.an@gmail.com)</b>로 문의 바랍니다.
	</div>
	<br><br>
	<h3><a href="${contextPath}/member/joinForm.do">가입하기<i class="fa fa-sign-out"></i></a></h3>
	
</div>
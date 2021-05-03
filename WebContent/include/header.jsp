<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("UTF-8");
%>

<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />

<!--   ##########################로그인 박스###################################################################### -->
<jsp:include page="../include/login.jsp" />
<!--   #######################로그인 박스 끝######################################################################### -->

<div class="relative bgded" style="background-color: #212427;">
	<!-- 페이지 위의 전호 ㅏ번호 같은ㄱ ㅓ -->
	<div class="wrapper row0">
		<div id="topbar" class="hoc clear">
			<!--   ################################################################################################ -->
			<div class="fl_left">
				<form id="searchBox" action="${contextPath}/item/search.do" method="get">
					<input type="text" class="searchBox" name="searchText" placeholder="Search">
					<button type="submit" class="searchClick bold">검색</button>
				</form>
			</div>

			<div class="fl_right topspace-10" id="headerButton">
				<ul class="fa nospace inline bold cursorPointer">
					<c:choose>
						<c:when test="${memberId==null}">
							<li>
								<a class="loginBtn">로그인 | </a>
							</li>
							<li>
								<a href="${contextPath}/member/joinPage.do">회원가입</a>
							</li>
						</c:when>
						<c:when test="${memberId!=null}">
							<li>
								<b>${memberId}님</b>이 로그인<i class="fa fa-envelope letterBtn letterBg"></i>|
							</li>
							<li>
								<a href="${contextPath}/member/myPage.do">MY PAGE | </a>
							</li>
							<li>
								<a href="${contextPath}/item/cartList.do">장바구니 | </a>
							</li>
							<li>
								<a href="${contextPath}/item/listOrder.do">주문 목록 | </a>
							</li>
							<li>
								<a href="${contextPath}/member/logout.do">로그아웃</a>
							</li>
						</c:when>
					</c:choose>
				</ul>
			</div>
			<!--   ###################################################################################################### -->
		</div>
	</div>
	<div id="container"></div>
</div>
<!--   #################로그인 권한확인 끝############################################################################### -->

<div class="wrapper row1">
	<header id="header" class="hoc clear">
		<!--#####################로고 및 메뉴바 인클루드######################################################### -->
		<div id="logo" class="fl_left bold">
			<h1>
				<a href="${contextPath}/member/main.do"><img class="roomdyLogo" alt="" src="${contextPath}/css/imgLogo/roomdyLogo.png"></a>
			</h1>
		</div>
		<nav id="mainav" class="fl_right logoBar">
			<ul class="clear">
				<li class="active bold">
					<a href="${contextPath}/member/main.do">Home</a>
				</li>
				<li>
					<a class="drop" href="${contextPath}/item/itemShowroom.do">KID가구</a>
					<ul>
						<li>
							<a href="${contextPath}/item/itemShowroom.do?itemCate=chair">의자</a>
						</li>
						<li>
							<a href="${contextPath}/item/itemShowroom.do?itemCate=closet">옷장</a>
						</li>
						<li>
							<a href="${contextPath}/item/itemShowroom.do?itemCate=light">조명</a>
						</li>
						<li>
							<a href="${contextPath}/item/itemShowroom.do?itemCate=wallpaper">벽지</a>
						</li>
						<li>
							<a href="${contextPath}/item/itemShowroom.do?itemCate=toy">장난감</a>
						</li>
						<li>
							<a href="${contextPath}/item/itemShowroom.do?itemCate=desk">책상</a>
						</li>
					</ul>
				</li>
				<li>
					<a href="${contextPath}/item/recomend.do">상품추천</a>
				</li>
				<li>
					<a href="${contextPath}/board/listReview.do">후기</a>
				</li>
				<li>
					<a class="drop" href="${contextPath}/board/csCenterPage.do">고객센터</a>
					<ul>
						<li>
							<a href="${contextPath}/board/csCenterPage.do?postCate=notice">공지사항</a>
						</li>
						<li>
							<a href="${contextPath}/board/csCenterPage.do?postCate=faq">자주 묻는 질문</a>
						</li>
						<li>
							<a href="${contextPath}/board/csCenterPage.do?postCate=qna">내 문의</a>
						</li>
					</ul>
				</li>
				<li>
					<a class="drop" href="#">이벤트</a>
					<ul>
						<li>
							<a href="#">할인쿠폰</a>
						</li>
						<li>
							<a href="#">할인판매</a>
						</li>
						<li>
							<a href="#">공동구매</a>
						</li>
					</ul>
				</li>

			</ul>
		</nav>
		<!--################################################################################################ -->
	</header>
</div>
<!-- ################################################################################################ -->

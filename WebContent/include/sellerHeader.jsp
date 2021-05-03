<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("UTF-8");
%>

<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />

<div class="relative bgded" style="background-color: #212427;">
	<!-- 헤더영역 -->
	<div class="wrapper row0">
		<div id="topbar" class="hoc clear">
			<!--   ################################################################################################ -->
			<div class="fl_right">
				<ul class="fa clear nospace inline">
					<li>
						<a>
							판매자 ${memberId}님 개인 페이지<i class="fa fa-envelope letterBtn letterBg"></i>|
						</a>
					</li>
					<li>
						<a href="${contextPath}/member/myPage.do">MY PAGE | </a>
					</li>
					<li>
						<a href="${contextPath}/member/logout.do">로그아웃</a>
					</li>
				</ul>
			</div>
			<!--   ################################################################################################ -->
		</div>
	</div>
	<div class="wrapper row1">
		<header id="header" class="hoc clear">
			<!--#####################로고 및 메뉴바 인클루드######################################################### -->
			<div id="logo" class="fl_left">
				<h1>
					<a href="${contextPath}/member/main.do">
						<img class="roomdyLogo" alt="" src="${contextPath}/css/imgLogo/roomdyLogo.png">
						(판매자 모드)
					</a>
				</h1>
			</div>
			<nav id="mainav" class="fl_right logoBar">
				<ul class="clear">
					<li class="active">
						<a href="${contextPath}/member/main.do">Home</a>
					</li>
					<li>
						<span class="drop" href="#">상품</span>
						<ul>
							<li>
								<a href="${contextPath}/item/itemUploadPage.do">상품등록</a>
							</li>
							<li>
								<a href="${contextPath}/item/itemList.do">등록된 상품 조회</a>
							</li>
						</ul>
					</li>
					<li>
						<a href="${contextPath}/item/listSoldItem.do">주문조회</a>
					</li>
					<li>
						<a href="${contextPath}/board/postWirtePage.do?postCate=qna">문의(관리자에게)</a>
					</li>
				</ul>
			</nav>
			<!--################################################################################################ -->
		</header>
	</div>
	<!--   ################################################################################################ -->
</div>

<script type="text/javascript">
	$(".letterBtn").click(
			function() {
				var W = 600;
				var H = 500;

				// 팝업을 가운데 위치시키기 위해 아래와 같이 값 구하기
				var L = Math.ceil((window.screen.width - W) / 2);
				var T = Math.ceil((window.screen.width - H) / 2);

				window.open("${contextPath}/member/letterPage.do", "쪽지함",
						'width=' + W + ', height=' + H + ', left=' + L
								+ ', top=' + T + ' scrollbars=no')
			});
</script>
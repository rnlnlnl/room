<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- JSTL의 CORE라이브러리에 속한 태그들을 사용 하기 위해 링크 작성 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- 컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../../scripts/roomdy/myPageScript.jsp" />

<form method="post" action="${contextPath}/member/modMember.do" id="modForm" name="fr">
	<section id="section">
		<label id="joinFontSize">
			고객 분류
			<c:choose>
				<c:when test="${memberBean.auth == 'B'}">
					<c:set var="authString" value="구매자" />
				</c:when>
				<c:when test="${memberBean.auth == 'S'}">
					<c:set var="authString" value="판매자" />
				</c:when>
			</c:choose>
			<input type="text" id="memAuth" name="auth" value="${authString}" class="disabled boxSize">
		</label>
		<hr>
		<br>
		<label for="id" id="joinFontSize">아이디</label>
		<input type="text" name="id" id="id" value="${memberBean.id}" class="disabled boxSize" />
		<br>
		<label id="joinFontSize">비밀번호</label>
		<input type="button" value="비밀번호 변경" class="boxSize btn marginBo" onclick="modPwShow()" />
		<span id="modPw"></span>
		<div id="modPwBox" class="initDisplayNone">
			<div id="typeList" class="modPwd">
				<div>
					<label for="originalPw" class="modPadTop">현재 비밀번호</label>
					<a class="closeModPwBox bold">닫기</a>
				</div>
				<input type="password" name="originalPw" id="originalPw" class="boxSize" />
				<label for="chagePw" class="modPadTop">변경할 비밀번호</label>

				<input type="password" name="chagePw" id="pw" class="boxSize" />
				<div id="typeList">
					<label for="chagePw2" class="modPadTop">변경할 비밀번호 확인</label>
					<span id="passCheck">&nbsp;&nbsp;</span>
				</div>
				<input type="password" name="chagePw2" id="pw2" class="boxSize" onblur="checkPass()" />

				<a class="initDisplayNone modPadTop" id="modPwBtn" onclick="modPw()">비밀번호 변경</a>
			</div>
		</div>
		<br>
		<label for="name" class="authB" id="joinFontSize">이름</label>
		<label for="name" class="authS" id="joinFontSize">회사명</label>
		<input type="text" name="name" id="name" value="${memberBean.name}" class="disabled boxSize" />
		<br>
		<label for="nickname" class="authB" id="joinFontSize">닉네임</label>
		<label for="nickname" class="authS" id="joinFontSize">사업자번호</label>
		<input type="text" name="nickname" id="nickname" value="${memberBean.nickname}" class="readonly boxSize" />
		<br>

		<div class="row">
			<div class="form-group col-xs-9 col-sm-9col-md-9 col-lg-9" id="typeList">
				<label for="email" id="joinFontSize">이메일</label>
				<b><span id="checkEmail">&nbsp;</span></b>
			</div>
			<div class="modMode form-group col-xs-9 col-sm-9col-md-9 col-lg-9" id="typeList">
				<input type="email" name="email" id="email" class="readonly id form-control typeListWid" placeholder="hello@hello.com" value="${memberBean.email}">
				<input type="button" id="certBtn" value="메일인증" class="buttonBox dup btn btn btn-block m-t-md" onclick="certEmail()">
				<br>
			</div>
		</div>
		<br>
		<label for="addr2" id="joinFontSize">주소</label>
		<div id="typeList">
			<input type="text" name="zipcode" id="zipcode" placeholder="우편번호" class="typeListWid" value="${memberBean.zipcode}" readonly>
			<input type="button" onclick="sample6_execDaumPostcode()" class="modMode initDisplayNone buttonBox btn" value="주소검색">
		</div>
		<br>
		<input type="text" id="addr1" name="addr1" placeholder="주소" value="${memberBean.addr1}" class="boxSize" readonly>
		<br>
		<input type="text" id="addr2" name="addr2" placeholder="상세주소" value="${memberBean.addr2}" class="boxSize">
		<br>

		<c:if test="${auth=='B' or auth =='b'}">
			<div id="authBuyer" class="typeB_S">
				<label for="style" id="joinFontSize" id="joinFontSize">선호 스타일</label>
				<nav id="typeList">
					<label class="typeB_S">
						<input type="radio" name="style" id="qute" value="큐트" <c:if test = "${memberBean.style == 'qute'}">checked</c:if> checked="checked">
						<span class="spanw">큐트</span>
					</label>

					<label class="typeB_S">
						<input type="radio" name="style" id="modern" value="모던" <c:if test = "${memberBean.style == 'modern'}">checked</c:if>>
						<span class="spanw">모던</span>
					</label>

					<label class="typeB_S">
						<input type="radio" name="style" id="anymation" value="애니메이션" <c:if test = "${memberBean.style == 'anymation'}">checked</c:if>>
						<span class="spanw">애니메이션</span>
					</label>

					<label class="typeB_S">
						<input type="radio" name="style" id="smart" value="스마트" <c:if test = "${memberBean.style == 'smart'}">checked</c:if>>
						<span class="spanw">스마트</span>
					</label>
				</nav>
			</div>
		</c:if>

		<br>
		<div id="typeList" class="paddingBo">
			<a class="one_half first modifyMem btn" id="memInfoModBtn" onclick="modInfoMod()">회원수정</a>
			<input type="reset" class="one_half btn myPageRe" id="setbtn" value="다시쓰기" />

		</div>
		<br>
		<hr>
		<input type="button" value="탈퇴하기" id="delMemberBtn" class="boxSize">
	</section>
</form>

<form action="${contextPath}/member/delMember.do" id="delMemForm" class="initDisplayNone">

	<section id="section">
		<div id="delMemberConfirmBox" class="defaultBorder">
			<h2>탈퇴를 원하신다면 비밀번호를 입력하여 주십시오.</h2>
			<input type="password" name="delConfPw" class="boxSize">
			<span id="delConfPwText"></span>
			<div class="divMar">
				<input class="one_half first" type="reset" value="탈퇴 취소" class="delBox">
				<button class="one_half" onclick="delPwChe" class="delBox">회원탈퇴</button>
			</div>
		</div>
	</section>
</form>
